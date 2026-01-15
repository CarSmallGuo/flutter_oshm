## 版本概述
本版本为Flutter OpenHarmony平台0.1.0版本（canary1），基于Flutter 3.27.4版本适配。本版本支持和完善OpenHarmony平台侧能力，提供平台化Channel、外接纹理、云端SDK等特性，并优化性能。

## 基础特性
- 支持OpenHarmony平台Flutter Channel
- 支持OpenHarmony平台Flutter Engine
- 支持OpenHarmony平台Flutter命令行工具
- 支持外接纹理
- 支持云端SDK

## 新增特性
- flutter_embedding支持ets产物和native产物分开引用
- 新增单独上传flutter.har和symbols.zip的脚本
- 增加查询ltpo开启状态的接口
- 添加DEP_ohos，依赖三方库分仓构建
- 优化帧率投票；新增纹理投票
- 重构轴事件处理，适配更多场景

## Bug修复
- 修复了 Rect.fromLTRB 显示问题
- 解决了在 Windows 系统上执行“flutter clean”命令时无法正确删除构建目录和 oh_modules 目录的问题
- 解决了在 Mac ARM64 系统上进行 Flutter 构建时 gen_snapshot 的路径问题
- 修复了 Dart 跟踪模式下应用程序卡顿的问题
- 解决了 3.35 版本中测试字段键盘无法缩回的问题
- 解决在剪切操作后无法进行粘贴的问题
- 修复ohos平台运行build命令，无法生成指定的文件夹
- 解决了在 AndroidStudio 上某些断点无法断住的问题

## 版本发布时间
2026年3月30日

## 版本配套
- OpenHarmony API20
- Flutter SDK: 3.35.7-ohos-0.0.1（由于flutter版本解析规则，为了避免版本比较解析失败，将显示为3.35.8-ohos-0.0.1-canary1）

## Changelog
- [3.35.7-ohos-0.0.1](../CHANGELOG_OHOS.md)

## 赋能文档
- [文档链接](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
