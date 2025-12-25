## Version Overview
This version is an OpenHarmony version based on Flutter 3.7.12. This version supports and improves the capabilities of the OpenHarmony platform and improves stability.

## New Features
- Add exception catching in the copyResource method, and add try catch and exception logging

## BugFix
- Fixed the issue where the focus of the input box switched between applications during split-screen, and the candidate word display position was incorrect after switching to flutter and entering characters
- Solve the problems of asynchronous attach and candidate word following in multiple input boxes
- Optimize the position of the candidate words to the lower right corner of the cursor and modify the way to obtain the coordinates
- Fixed the issue of incorrect distribution of mouse and gesture events in multiple Flutter Views
- Solve the problem of page retraction when switching to left and right split-screen after opening the fixed soft keyboard on the upper and lower split-screen
- Fixed the issue where the release build of Flutter 3.7 fails to run on the Windows emulator
- Solve the problem of thread conflicts when setting up a pixelmap with an external texture using atomic variables
- Fixed the memory leak issue in 3.7Channel

## Version Release Time
Dec 25, 2025

## Version Support
- OpenHarmony API20
- Flutter SDK: 3.7.12-ohos-1.1.8

## Changelog
- [6.0.3.21, 6.0.3.20, 6.0.3.17, 6.0.2.122, 6.0.2.121](../CHANGELOG.md)

## Enablement Documents
- [Document Link](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)
