// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:native_assets_builder/native_assets_builder.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_assets_cli/native_assets_cli_internal.dart';

import '../../../ohos/ohos_sdk.dart';
import '../../../base/common.dart';
import '../../../base/file_system.dart';
import '../../../build_info.dart' hide BuildMode;
import '../../../globals.dart' as globals;


Future<void> copyNativeCodeAssetsOhos(
  Uri buildUri,
  Map<NativeCodeAssetImpl, KernelAsset> assetTargetLocations,
  FileSystem fileSystem,
) async {
  if (assetTargetLocations.isNotEmpty) {
    globals.logger
        .printTrace('Copying native assets to ${buildUri.toFilePath()}.');
    final List<String> archDirs = <String>[
      for (final OhosArch ohosArch in OhosArch.values)
        ohosArch.archName,
    ];
    for (final String arcDir in archDirs) {
      final Uri archUri = buildUri.resolve('libs/$arcDir/');
      await fileSystem.directory(archUri).create(recursive: true);
    }
    for (final MapEntry<NativeCodeAssetImpl, KernelAsset> assetMapping
        in assetTargetLocations.entries) {
      final Uri source = assetMapping.key.file!;
      final Uri target = (assetMapping.value.path as KernelAssetAbsolutePath).uri;
      final OhosArch ohosArch =
          _getOhosArch(assetMapping.value.target);
      final String archDir = ohosArch.archName;
      final Uri archUri = buildUri.resolve('libs/$archDir/');
      final Uri targetUri = archUri.resolveUri(target);
      final String targetFullPath = targetUri.toFilePath();
      await fileSystem.file(source).copy(targetFullPath);
    }
    globals.logger.printTrace('Copying native assets done.');
  }
}

/// Get the [Target] for [ohosArch].
Target getNativeOhosTarget(OhosArch ohosArch) {
  return switch (ohosArch) {
    OhosArch.armeabi_v7a => Target.ohosArm,
    OhosArch.arm64_v8a   => Target.ohosArm64,
    OhosArch.x86_64      => Target.ohosX64,
  };
}

/// Get the [OhosArch] for [target].
OhosArch _getOhosArch(Target target) {
  return switch (target) {
    Target.ohosArm   => OhosArch.armeabi_v7a,
    Target.ohosArm64 => OhosArch.arm64_v8a,
    Target.ohosX64   => OhosArch.x86_64,
    _ => throwToolExit('Invalid target: $target.'),
  };
}

Map<NativeCodeAssetImpl, KernelAsset> assetTargetLocationsOhos(
    List<NativeCodeAssetImpl> nativeAssets) {
  return <NativeCodeAssetImpl, KernelAsset>{
    for (final NativeCodeAssetImpl asset in nativeAssets)
      asset: _targetLocationOhos(asset),
  };
}

/// Converts the `path` of [asset] as output from a `build.dart` invocation to
/// the path used inside the Flutter app bundle.
KernelAsset _targetLocationOhos(NativeCodeAssetImpl asset) {
  final LinkMode linkMode = asset.linkMode;
  final KernelAssetPath kernelAssetPath;
  switch (linkMode) {
    case DynamicLoadingSystem _:
      kernelAssetPath = KernelAssetSystemPath(linkMode.uri);
    case LookupInExecutable _:
      kernelAssetPath = KernelAssetInExecutable();
    case LookupInProcess _:
      kernelAssetPath = KernelAssetInProcess();
    case DynamicLoadingBundled _:
      final String fileName = asset.file!.pathSegments.last;
      kernelAssetPath = KernelAssetAbsolutePath(Uri(path: fileName));
    default:
      throw Exception(
        'Unsupported asset link mode $linkMode in asset $asset',
      );
  }
  return KernelAsset(
    id: asset.id,
    target: Target.fromArchitectureAndOS(asset.architecture!, asset.os),
    path: kernelAssetPath,
  );
}

/// Looks the NDK clang compiler tools.
///
/// Tool-exits if the NDK cannot be found.
///
/// Should only be invoked if a native assets build is performed. If the native
/// assets feature is disabled, or none of the packages have native assets, a
/// missing NDK is okay.
Future<CCompilerConfigImpl> cCompilerConfigOhos() async {
  final OhosSdk? ohosSdk = OhosSdk.localOhosSdk();
  if (ohosSdk == null) {
    throwToolExit('Ohos SDK could not be found.');
  }
  final CCompilerConfigImpl result = CCompilerConfigImpl(
    compiler: _toOptionalFileUri(ohosSdk.getNdkClangPath()),
    archiver: _toOptionalFileUri(ohosSdk.getNdkArPath()),
    linker: _toOptionalFileUri(ohosSdk.getNdkLdPath()),
  );
  if (result.compiler == null ||
      result.archiver == null ||
      result.linker == null) {
    throwToolExit('Ohos NDK Clang could not be found.');
  }
  return result;
}

Uri? _toOptionalFileUri(String? string) {
  if (string == null) {
    return null;
  }
  return Uri.file(string);
}
