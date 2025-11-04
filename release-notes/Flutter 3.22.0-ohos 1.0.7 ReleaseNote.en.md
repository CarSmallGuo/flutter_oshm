## Version Overview
This version is an OpenHarmony version based on Flutter 3.22.0. This version supports and improves the capabilities of the OpenHarmony platform and improves stability.

## New Features
- When destroying an xcomponent, send a cancel signal to the gesture currently being processed
- Update the fluttertpc dart sdk repository version to f5029bd2
- Update the fluttertpc dart sdk repository version to ee0af3db
- When compiling and uploading debug engine products, change to default not to use the unoptimized option

## BugFix
- Fixed the issue of log screen flooding caused by AcquireBuffer when no new frames were generated
- Fixed the Channel memory leak issue
- Fixed the issue where mouse/two-finger swiping could not scroll when using multiple web pages
- Fix for rendering anomalies in dirty areas during pre-rendering
- Fixed the occasional bottomRect error issue
- Fixed the issue where vulkan DestroyImageView crashed when the app clicked the back button
- Handle the HarmonyOS exception touchevent
- Fix the issue where calling the setWindowLayoutFullScreen interface on a PC does not take effect
- Solve the problems that may cause the image source uaf
- Solve the problem of deleting exceptions in delta mode

## Version Release Time
Nov 4, 2025

## Version Support
- OpenHarmony API20
- Flutter SDK: 3.22.0-ohos-1.0.7(Due to Flutter version parsing rules, to avoid version comparison failures, it will display as 3.22.1-ohos-1.0.7)

## Changelog
- [6.0.0.705, 6.0.0.704, 6.0.0.701, 6.0.0.700](../CHANGELOG.md)

## Enablement Documents
- [Document Link](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
