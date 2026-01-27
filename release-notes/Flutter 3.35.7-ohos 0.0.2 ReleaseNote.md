## 版本概述
本版本为基于Flutter 3.35.7版本适配。本版本支持和完善OpenHarmony平台侧能力，提供平台化Channel、外接纹理、云端SDK等特性，并优化性能。

## 新增特性
- feat: notify OHOS when navigate in Flutter
- 增加json5文件注释特性解析支持
- 滑动丢帧事件上报添加FRAME_ID属性与总帧数属性

## Bug修复
- 退后台释放DMA资降低内存
- 修改Column溢出到Column溢出切换,缩放值不准确问题
- Fix cache errors related to YUVConversionVK.
- fix: false error log when notify page change successfully
- Fixed occasional connection failures in flutter run.
- Run 'bin/et format'
- 修改napi相关的内存泄露问题
- Add HarmonyOS platform detection


## 版本配套
- 编译引擎版本要求： OpenHarmony API 23及以上
- Flutter SDK: 3.35.7-ohos-0.0.2（由于flutter版本解析规则，为了避免版本比较解析失败，将显示为3.35.8-ohos-0.0.2）

## Changelog
- [3.35.7-ohos-0.0.2](../CHANGELOG_OHOS.md)

## 赋能文档
- [文档链接](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
