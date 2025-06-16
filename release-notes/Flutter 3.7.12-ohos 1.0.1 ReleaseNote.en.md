## Version Overview
This version is Flutter OpenHarmony platform 1.0.1, based on Flutter 3.7.12 version. This version supports and enhances the platform-side capabilities of OpenHarmony, providing features such as large font accessibility, English documents, and third-party libraries. 

## Release scope
HarmonyOS NEXT, API12


## New features
- Support for large font capability in accessibility mode
- Provide English documentation
- Provide more third-party libraries 

## Release Date
September 29, 2024 

## Version Compatibility 

- ROM: 205.0.0.68
- IDE: DevEco Studio 5.0.3.810
- SDK: OpenHarmony 5.0.0.68
- Flutter SDK: 3.7.12-ohos-1.0.1 

## Development Documentation

- [Documentation Link](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs) 

## Third-party library list

|Library Name|Address|
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

Fixes:
- When using multiple PlatformViews in a hybrid app with native integration, the second page will not update the first PlatformView page when returning and returning to it.
- Resolves the crashing issue when running in debug mode.