# 升级指导

本升级指导适用于所有基于 OpenHarmony 适配的 Flutter 版本，适合开发者在进行鸿蒙 Flutter 项目升级、迁移或维护时参考。请严格遵循官方流程，确保开发环境和项目兼容性。

## 一、升级适用场景

1. OpenHarmony Flutter 项目从旧版本升级至新版本。
2. 其他平台（如 Android/iOS）Flutter 项目迁移至鸿蒙 Flutter。

## 二、升级前准备

1. **备份项目代码与依赖配置**，确保可随时回滚。

2. **确认本地开发环境已安装所需依赖**。

3. **拉取新版本 OpenHarmony Flutter SDK **：
   
   ```shell
   git clone -b {新版本分支} https://gitcode.com/openharmony-tpc/flutter_flutter.git
   ```
   
4. **配置环境变量**，详见 [flutter_flutter](https://gitcode.com/openharmony-tpc/flutter_flutter) 的 `环境依赖` 章节。

## 三、升级流程

1. **检查开发环境**
   - 运行 `flutter doctor -v`，确保 Flutter 与 OpenHarmony 环境均为 OK。
2. **升级依赖**
   - 更新 `pubspec.yaml` 中三方库版本，确保兼容当前 Flutter 版本。
   - 执行 `flutter pub upgrade`。
3. **迁移与适配项目代码**
   - 关注 Flutter 官方 API 变更、平台差异，参考[官方变更说明](https://docs.flutter.dev/release/release-notes)逐步调整。
   - 如涉及渲染引擎切换（如 impeller-vulkan/skia-gl），请参考官方配置说明。
4. **编译与验证**
   - 使用 `flutter build hap` 命令编译应用。
   - 使用 `hdc install entry.hap` 命令将应用安装到鸿蒙设备或模拟器上运行，全面验证功能与兼容性。

## 四、常见问题与支持

- 升级过程中遇到兼容性或构建问题，请优先查阅 [Flutter Release Notes](https://docs.flutter.dev/release/release-notes) 与 [Breaking Changes](https://docs.flutter.dev/release/breaking-changes)。
- 鸿蒙专用包问题请在 [flutter_packages](https://gitcode.com/openharmony-tpc/flutter_packages) 仓库提交 issue。
- 其他问题可在主仓库 issue 区反馈。

## 五、参考文档
- [鸿蒙 Flutter 开发文档](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
- [Flutter 官方文档](https://docs.flutter.dev/)
- [OpenHarmony 官方文档](https://openharmony.cn/)

