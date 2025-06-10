## 版本概述
本版本为Flutter OpenHarmony平台1.0.1版本，基于Flutter 3.7.12版本适配。本版本支持和完善OpenHarmony平台侧能力，提供无障碍大字体、英文文档、三方库等。

## 发布范围
HarmonyOS NEXT, API12

## 新增特性
- 支持无障碍模式大字体能力
- 提供英文化文档
- 提供更多三方库

## 版本发布时间
2024年9月29日

## 版本配套

- ROM: 205.0.0.68
- IDE: DevEco Studio 5.0.3.810
- SDK: OpenHarmony 5.0.0.68
- Flutter SDK: 3.7.12-ohos-1.0.1

## 赋能文档

- [文档链接](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)

## 三方库列表
- 本次更新的三方库：

|三方库名称|仓库地址|
|:----|:----|
|yfree|https://gitcode.com/openharmony-sig/fluttertpc_flutter_yfree|
|r_upgrade|https://gitcode.com/openharmony-sig/fluttertpc_r_upgrade|
|flutter_custom_cursor|https://gitcode.com/openharmony-sig/fluttertpc_flutter_custom_cursor|
|scan|https://gitcode.com/openharmony-sig/fluttertpc_scan|
|flutter_downloader|https://gitcode.com/openharmony-sig/fluttertpc_flutter_downloader|
|open_app_settings|https://gitcode.com/openharmony-sig/fluttertpc_open_app_settings|
|mobile_scanner|https://gitcode.com/openharmony-sig/fluttertpc_mobile_scanner|
|flutter_qr_reader|https://gitcode.com/openharmony-sig/fluttertpc_flutter_qr_reader|
|open_filex|https://gitcode.com/openharmony-sig/fluttertpc_open_filex|
|auto_orientation|https://gitcode.com/openharmony-sig/fluttertpc_auto_orientation|
|flutter_filereader|https://gitcode.com/openharmony-sig/fluttertpc_flutter_filereader|
|flutter_phone_direct_caller|https://gitcode.com/openharmony-sig/fluttertpc_flutter_phone_direct_caller|
|media_info|https://gitcode.com/openharmony-sig/fluttertpc_media_info|
|get|https://gitcode.com/openharmony-sig/fluttertpc_get|
|catcher|https://gitcode.com/openharmony-sig/fluttertpc_catcher|
|flutter_document_picker|https://gitcode.com/openharmony-sig/fluttertpc_flutter_document_picker|
|flutter_keychain|https://gitcode.com/openharmony-sig/fluttertpc_flutter_keychain|
|flutter_udid|https://gitcode.com/openharmony-sig/fluttertpc_flutter_udid|
|r_scan|https://gitcode.com/openharmony-sig/fluttertpc_r_scan|
|pdf_viewer_plugin|https://gitcode.com/openharmony-sig/fluttertpc_pdf_viewer_plugin|
|flutter_keychain|https://gitcode.com/openharmony-sig/fluttertpc_flutter_keychain|
|audio_service|https://gitcode.com/openharmony-sig/fluttertpc_audio_service|

## 修复问题
- 多个PlatformView与原生混合开发时，打开第二个页面返回再返回第一个页面，第一个PlatformView页面不会更新
- 解决debug模式下运行闪退问题