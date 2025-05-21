## Version Overview
This version is an OpenHarmony version based on Flutter 3.7.12. This version supports and improves the capabilities of the OpenHarmony platform and improves stability.

## Release Scope
OpenHarmony API16

## BugFix
- Fix memory leak in NativeWindow when DetachFlutterEngine occurs before OnSurfaceDestroy
- Prevent deadlock when the external texture's producer task runs before OnNativeImageFrameAvailable task in platform thread.
- Fix the parameter format issue of interface setTextureBackGroundColor, change from ARGB to ABGR
- Unset the timeout waiting time for the request buffer of the local window to 0 to solve the flickering problem in some scenarios

## Version Release Time
May 21, 2025

## Version Support
- ROM: 5.0.1.120
- IDE: DevEco Studio 5.0.13.100
- Flutter SDK: 3.7.12-ohos-1.1.1

## Changelog
- [5.1.0.403SP1](/CHANGELOG.md)

## Enablement Documents
- [Document Link](https://gitcode.com/openharmony-sig/flutter_samples/tree/master/ohos/docs)
