/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE_KHZG file.
*/

import '../base/common.dart';
import '../globals.dart' as globals;
import '../ohos/ohos_plugins_manager.dart';
import '../project.dart';
import '../runner/flutter_command.dart';

class ListOhosCommand extends FlutterCommand {
  ListOhosCommand() {
    usesTargetOption();
  }

  @override
  final String name = 'list-ohos';

  @override
  final String description = '列出鸿蒙项目中的 Flutter 插件模块列表。';

  @override
  Future<FlutterCommandResult> runCommand() async {
    final FlutterProject project = FlutterProject.current();

    if (!project.ohos.existsSync()) {
      throwToolExit('当前项目不是鸿蒙项目或未包含鸿蒙配置。');
    }

    final List<String> moduleNames = await getFlutterModuleNameList(project);

    if (moduleNames.isEmpty) {
      globals.logger.printStatus('当前项目没有 Flutter 插件模块。');
    } else {
      globals.logger.printStatus('Flutter 插件模块列表:');
      for (final String moduleName in moduleNames) {
        globals.logger.printStatus('  • $moduleName');
      }
    }

    return FlutterCommandResult.success();
  }
}
