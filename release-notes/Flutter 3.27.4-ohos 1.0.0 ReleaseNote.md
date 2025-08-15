## 版本概述
本版本为基于Flutter 3.27.4适配的OpenHarmony版本。本版本支持和完善OpenHarmony平台侧能力，提升稳定性。

## 新增特性
- Replace the old interface with a non-copying memory interface in the image codec implementation
- The system font configuration is obtained from the system interface first and then from the JSON file
- Synchronize upstream community changes, no longer use encoder to handle vk_cmd_buffer

## Bug修复
- 修复模拟器上竖屏视频播放倒转的问题
- 修复多FlutterEntry情况下，生命周期异常的问题
- 修复鼠标点击事件导致的hover异常问题
- 修复api20设备外接键盘无法输入问题
- 修复ets中void运算符使用方法错误

## 版本发布时间
2025年8月15日

## 版本配套
- OpenHarmony API20
- Flutter SDK: 3.27.4-ohos-1.0.0（由于flutter版本解析规则，为了避免版本比较解析失败，将显示为3.27.5-ohos-1.0.0）

## Changelog
- [6.0.0.504](../CHANGELOG_OHOS.md)

## 赋能文档
- [文档链接](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
