## 版本概述
本版本为基于Flutter 3.22.0适配的OpenHarmony版本。本版本支持和完善OpenHarmony平台侧能力，提升稳定性。

## 发布范围
OpenHarmony API16

## BugFix
- 修复当先执行DetachFlutterEngine，后执行OnSurfaceDestroy时NativeWindow中的内存泄露
- 避免主线程外接纹理生产端死锁
- 修正外接纹理第一帧背景色颜色格式为ABGR
- impeller简单遮挡剔除 & 修复部分场景组件不渲染

## 版本发布时间
2025年5月21日

## 版本配套
- ROM: 5.0.1.120
- IDE: DevEco Studio 5.0.13.100
- Flutter SDK: 3.22.0-ohos-1.0.1

## Changelog
- [5.1.0.403SP1](/CHANGELOG.md)

## 赋能文档
- [文档链接](https://gitcode.com/openharmony-sig/flutter_samples/tree/master/ohos/docs)