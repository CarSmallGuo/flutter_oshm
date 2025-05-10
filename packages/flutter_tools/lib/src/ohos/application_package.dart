/*
* Copyright 2014 The Flutter Authors. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*
*/

import 'package:json5/json5.dart';
import 'package:process/process.dart';

import '../application_package.dart';
import '../base/common.dart';
import '../base/file_system.dart';
import '../base/logger.dart';
import '../base/process.dart';
import '../base/user_messages.dart';
import '../build_info.dart';
import '../globals.dart' as globals;
import '../project.dart';
import 'hvigor_utils.dart';
import 'ohos_sdk.dart';

const String OHOS_ENTRY_DEFAULT = 'entry';
const int OHOS_SDK_INT_DEFAULT = 11;

/// An application package created from an already built Ohos HAP.
class OhosHap extends ApplicationPackage implements PrebuiltApplicationPackage {
  OhosHap({
    required super.id,
    required this.applicationPackage,
    required this.ohosBuildData,
  })  : assert(applicationPackage != null),
        assert(ohosBuildData != null);

  @override
  final FileSystemEntity applicationPackage;

  OhosBuildData ohosBuildData;

  @override
  String? get name => applicationPackage.basename;

  /// Creates a new OhosHap based on the information in the Ohos build-profile.
  static Future<OhosHap?> fromOhosProject(
    OhosProject ohosProject, {
    required HarmonySdk? ohosSdk,
    required ProcessManager processManager,
    required UserMessages userMessages,
    required ProcessUtils processUtils,
    required Logger logger,
    required FileSystem fileSystem,
    BuildInfo? buildInfo,
  }) async {
    /// parse the build data
    final OhosBuildData ohosBuildData =
        OhosBuildData.parseOhosBuildData(ohosProject, logger);
    final String flavor = getFlavor(ohosProject.getBuildProfileFile(), buildInfo?.flavor);
    String bundleName = ohosBuildData.appInfo!.bundleName;
    final List<dynamic>? products = ohosBuildData.products;
    if (products != null) {
      for (final dynamic item in products) {
        final Map<String, dynamic> productItem = item as Map<String, dynamic>;
        if (flavor == productItem['name'] && productItem['bundleName'] != null) {
          bundleName = productItem['bundleName'] as String;
          ohosBuildData.appInfo!.bundleName = bundleName;
          break;
        }
      }
    }
    for (final OhosModule element in ohosBuildData.moduleInfo.moduleList) {
      element.flavor = flavor;
    }
    return OhosHap(
        id: bundleName,
        applicationPackage: ohosProject.getSignedHapFile(flavor),
        ohosBuildData: ohosBuildData);
  }

  static Future<OhosHap?> fromHap(
    File hap, {
    required HarmonySdk ohosSdk,
    required ProcessManager processManager,
    required UserMessages userMessages,
    required Logger logger,
    required ProcessUtils processUtils,
  }) async {
    final bool hapExists = await hap.exists();
    if (hapExists) {
      final File packInfo = hap.parent.childFile('pack.info');
      if (!packInfo.existsSync()) {
        throwToolExit(
            'Can not found pack.info at ${hap.parent.absolute.resolveSymbolicLinksSync()}');
      }

      final Map<String, dynamic> info = JSON5.parse(packInfo.readAsStringSync()) as Map<String, dynamic>;
      final Map<String, dynamic> summary = info['summary'] as Map<String, dynamic>;
      final Map<String, dynamic> app = summary['app'] as Map<String, dynamic>;
      final List<dynamic> modules = summary['modules'] as List<dynamic>;

      final String bundleName = app['bundleName'] as String;
      final String path = globals.fs.file(hap.absolute).resolveSymbolicLinksSync();
      final OhosBuildData ohosBuildData = OhosBuildData.parseOhosBuildDataFromInfo(app, modules, logger);

      return OhosHap(
          id: bundleName,
          applicationPackage: globals.fs.file(path),
          ohosBuildData: ohosBuildData);
    } else {
      throwToolExit('Can not found hap.');
    }
  }
}

/// OpenHarmony的构建信息
class OhosBuildData {
  OhosBuildData(this.appInfo, this.moduleInfo, this.apiVersion, this.products);

  late AppInfo? appInfo;
  late ModuleInfo moduleInfo;
  late int apiVersion;
  List<dynamic>? products;

  bool get hasEntryModule => false;

  List<OhosModule> get harModules {
    return moduleInfo.moduleList
        .where((OhosModule e) => e.type == OhosModuleType.har)
        .toList();
  }

  static OhosBuildData parseOhosBuildData(
      OhosProject ohosProject, Logger? logger) {
    late AppInfo appInfo;
    late ModuleInfo moduleInfo;
    late int apiVersion;
    List<dynamic>? products;
    try {
      final File appJson = ohosProject.getAppJsonFile();
      if (appJson.existsSync()) {
        final String json = appJson.readAsStringSync();
        final dynamic obj = JSON5.parse(json);
        appInfo = AppInfo.getAppInfo(obj);
      } else {
        appInfo = AppInfo('', 1, '');
      }
    } on Exception catch (err) {
      throwToolExit('Parse ohos app.json5 error: $err');
    }

    try {
      moduleInfo = ModuleInfo.getModuleInfo(ohosProject);
    } on Exception catch(err) {
      throwToolExit('Parse ohos module.json5 error: $err');
    }

    try {
      final File buildProfileFile = ohosProject.getBuildProfileFile();
      if (buildProfileFile.existsSync()) {
        final String buildProfileConfig = buildProfileFile.readAsStringSync();
        final dynamic obj = JSON5.parse(buildProfileConfig);
        apiVersion = getApiVersion(obj);
        // ignore: avoid_dynamic_calls
        if (obj['app'] != null && obj['app']['products'] != null) {
          // ignore: avoid_dynamic_calls
          products = obj['app']['products'] as List<dynamic>;
        }
      } else {
        apiVersion = OHOS_SDK_INT_DEFAULT;
      }
    } on Exception catch (err) {
      throwToolExit('Parse ohos build-profile.json5 error: $err');
    }
    return OhosBuildData(appInfo, moduleInfo, apiVersion, products);
  }

  static OhosBuildData parseOhosBuildDataFromInfo(
      Map<String, dynamic> app, List<dynamic> modules, Logger? logger) {
    late AppInfo appInfo;
    late ModuleInfo moduleInfo;
    late int apiVersion;
    List<dynamic>? products;

    // appInfo
    final Map<String, dynamic> version = app['version'] as Map<String, dynamic>;
    appInfo = AppInfo(app['bundleName'] as String, version['code'] as int, version['name'] as String);

    // moduleInfo
    moduleInfo = ModuleInfo.getModuleInfoFromInfo(modules);

    // apiVersion
    final Map<String, dynamic> apiVersionInfo = (modules.first
    as Map<String, dynamic>)['apiVersion'] as Map<String, dynamic>;
    apiVersion = apiVersionInfo['compatible'] as int;

    // products
    final Map<String, dynamic> product = <String, dynamic>{};
    product['name'] = 'default';
    product['signingConfig'] = 'default';
    product['compatibleSdkVersion'] = getCompatibleSdkVersion(apiVersion);
    product['runtimeOS'] = 'HarmonyOS';
    products = <dynamic>[product];

    return OhosBuildData(appInfo, moduleInfo, apiVersion, products);
  }

  static String getCompatibleSdkVersion(int apiVersion) {
    switch (apiVersion) {
      case 11:
        return '4.1.0(11)';
      case 12:
        return '5.0.0(12)';
      case 13:
        return '5.0.1(13)';
      case 14:
        return '5.0.2(14)';
      case 15:
        return '5.0.3(15)';
      case 16:
        return '5.0.4(16)';
      case 17:
        return '5.0.5(17)';
      case 18:
        return '5.1.0(18)';
      default:
        return '5.0.0(12)';
    }
  }
}

int getApiVersion(dynamic obj) {
  // ignore: avoid_dynamic_calls
  dynamic sdkObj = obj['app']?['compatibleSdkVersion'];
  // ignore: avoid_dynamic_calls
  sdkObj ??= obj['app']?['products'][0]['compatibleSdkVersion'];
  if (sdkObj is int) {
    return sdkObj;
  } else if (sdkObj is String && sdkObj != null) { // 4.1.0(11)
    String? str = RegExp(r'\(\d+\)').stringMatch(sdkObj);
    if (str != null) {
      str = str.substring(1, str.length - 1);
      return int.parse(str);
    }
  }
  return OHOS_SDK_INT_DEFAULT;
}

class AppInfo {
  AppInfo(this.bundleName, this.versionCode, this.versionName);

  late String bundleName;
  late int versionCode;
  late String versionName;

  static AppInfo getAppInfo(dynamic app) {
    final String bundleName = app['app']['bundleName'] as String;
    final int versionCode = app['app']['versionCode'] as int;
    final String versionName = app['app']['versionName'] as String;
    return AppInfo(bundleName, versionCode, versionName);
  }
}

class ModuleInfo {
  ModuleInfo(this.moduleList);

  List<OhosModule> moduleList;

  bool get hasEntryModule =>
      moduleList.any((OhosModule element) => element.isEntry);

  OhosModule? get entryModule => hasEntryModule
      ? moduleList.firstWhere((OhosModule element) => element.isEntry)
      : null;

  String? get mainElement => entryModule?.mainElement;

  /// 获取主要的module名，如果存在entry，返回entry类型的module，否则返回第一个module
  String get mainModuleName =>
      entryModule?.name ??
      (moduleList.isNotEmpty ? moduleList.first.name : OHOS_ENTRY_DEFAULT);

  /// 获取主要的module路径，如果存在entry，返回entry类型的module，否则返回第一个module
  String get mainModuleSrcPath =>
      entryModule?.srcPath ??
      (moduleList.isNotEmpty ? moduleList.first.srcPath : OHOS_ENTRY_DEFAULT);

  static ModuleInfo getModuleInfo(OhosProject ohosProject) {
    return ModuleInfo(OhosModule.fromOhosProject(ohosProject));
  }

  static ModuleInfo getModuleInfoFromInfo(List<dynamic> modules) {
    return ModuleInfo(OhosModule.fromInfo(modules));
  }
}

enum OhosModuleType {
  entry,
  har,
  shared,
  unknown;

  static OhosModuleType fromName(String name) {
    return OhosModuleType.values.firstWhere(
        (OhosModuleType element) => element.name == name,
        orElse: () => OhosModuleType.unknown);
  }
}

class OhosModule {
  OhosModule({
    required this.name,
    required this.srcPath,
    required this.isEntry,
    required this.mainElement,
    required this.type,
    required this.flavor,
  });

  final String name;
  final bool isEntry;
  final String? mainElement;
  final OhosModuleType type;
  final String srcPath;
  String flavor;

  static List<OhosModule> fromOhosProject(OhosProject ohosProject) {
    final File buildProfileFile = ohosProject.ohosRoot.childFile('build-profile.json5');
    if (!buildProfileFile.existsSync()) {
      return <OhosModule>[];
    }
    final Map<String, dynamic> buildProfile = JSON5.parse(buildProfileFile.readAsStringSync()) as Map<String, dynamic>;
    if (!buildProfile.containsKey('modules')) {
      return <OhosModule>[];
    }
    final List<dynamic> modules = buildProfile['modules'] as List<dynamic>;
    return modules.map((dynamic e) {
      final Map<String, dynamic> module = e as Map<String, dynamic>;
      final String srcPath = module['srcPath'] as String;
      return OhosModule.fromModulePath(
          modulePath: globals.fs.path.join(ohosProject.ohosRoot.path, srcPath));
    }).toList();
  }

  static List<OhosModule> fromInfo(List<dynamic> modules) {
    return modules.map((dynamic e) {
      final Map<String, dynamic> module = e as Map<String, dynamic>;
      final Map<String, dynamic> distro = module['distro'] as Map<String, dynamic>;
      final String name = distro['moduleName'] as String;
      final String type = distro['moduleType'] as String;
      final bool isEntry = type == OhosModuleType.entry.name;
      final String modulePath = globals.fs.path.join(
          globals.fs.currentDirectory.resolveSymbolicLinksSync(), 'ohos', name);
      return OhosModule(
        name: name,
        srcPath: modulePath,
        isEntry: isEntry,
        mainElement: isEntry ? module['mainAbility'] as String : null,
        type: OhosModuleType.fromName(type),
        flavor: FLAVOR_DEFAULT,
      );
    }).toList();
  }

  static OhosModule fromModulePath({
    required String modulePath,
    String? flavor,
  }) {
    modulePath = globals.fs.path.normalize(globals.fs.file(modulePath).resolveSymbolicLinksSync());
    final String moduleJsonPath =
        globals.fs.path.join(modulePath, 'src', 'main', 'module.json5');
    final File moduleJsonFile = globals.fs.file(moduleJsonPath);
    if (!moduleJsonFile.existsSync()) {
      throwToolExit('Can not found module.json5 at $moduleJsonPath . \n'
          '  You need to update the Flutter plugin project structure. \n'
          '  See https://gitee.com/openharmony-sig/flutter_samples/tree/master/ohos/docs/09_specifications/update_flutter_plugin_structure.md');
    }
    try {
      final Map<String, dynamic> moduleJson = JSON5
          .parse(moduleJsonFile.readAsStringSync()) as Map<String, dynamic>;
      final Map<String, dynamic> module =
          (moduleJson['module'] as Map<dynamic, dynamic>).cast();
      final String name = module['name'] as String;
      final String type = module['type'] as String;
      final bool isEntry = type == OhosModuleType.entry.name;
      return OhosModule(
        name: name,
        srcPath: modulePath,
        isEntry: isEntry,
        mainElement: isEntry ? module['mainElement'] as String : null,
        type: OhosModuleType.fromName(type),
        flavor: flavor ?? FLAVOR_DEFAULT,
      );
    } on Exception catch (e) {
      throwToolExit('parse module.json5 error , $moduleJsonPath . error: $e');
    }
  }
}
