# Changelog

## 3.35.7-ohos-0.0.2
- 退后台释放DMA资降低内存,([3c16902d6d](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/3c16902d6d36ad07a66dd2e7db8217e14a88b27f))
- 修改Column溢出到Column溢出切换,缩放值不准确问题,([8566144b71](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/8566144b710c4db2f18c1997f57420250bee01e6))
- memory leak,([9133d8c390](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/9133d8c390a880f56f23f17c63bcfc7dd213f1f6))
- Fix cache errors related to YUVConversionVK.,([bafc977c9f](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/bafc977c9f5dca9040a638c6a688090b910ae11e))
- fix: false error log when notify page change successfully,([a0cc88cc68](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/a0cc88cc68b19418c85f7cc706d74d1364ac2426))
- Fixed occasional connection failures in flutter run.,([636156bbb9](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/636156bbb99f4156110ddf00d0af2fddaa46c28e))
- feat: notify OHOS when navigate in Flutter,([f1c523d92e](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/f1c523d92e2a6abc27e5de9d0c8acbb9167fa0e3))
- Run 'bin/et format',([4070fb8db5](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/4070fb8db5dfe15b32425d13bfad6be909d05026))
- 修改napi相关的内存泄露问题,([c76408b848](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/c76408b848583c0854fb13b0a6e23f0b758aea17))
- 增加json5文件注释特性解析支持,([5715503dc6](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/5715503dc61f217f51a9e08e4b412b0f3d769eeb))
- Add HarmonyOS platform detection,([4876bb62c5](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/4876bb62c5abcca51f9de69e6fde25831c832a03))
- 【3.35】滑动丢帧事件上报添加FRAME_ID属性与总帧数属性,([f26d64e2a1](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/f26d64e2a1dab1d0d1371399c8b581edc45cb12d))

## 3.35.7-ohos-0.0.1-canary1
- 修复了 Rect.fromLTRB 显示问题 [fa000541](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/fa0005417c1523219c7b473d2f6f2166efa6ad29?ref=oh-3.35.7-dev&prId=772)
- 解决了在 Windows 系统上执行“flutter clean”命令时无法正确删除构建目录和 oh_modules 目录的问题[a26402fe](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/a26402fe546bf4d88b9dca40d0ab06d48831f25c?ref=oh-3.35.7-dev&prId=772)
- 解决了在 Mac ARM64 系统上进行 Flutter 构建时 gen_snapshot 的路径问题[3dcdf735](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/3dcdf735fbf633e7788d33ff8669c4b50778d140?ref=oh-3.35.7-dev&prId=772)
- 修复了 Dart 跟踪模式下应用程序卡顿的问题[ae07d24d](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/ae07d24da7f084c7218b59f1b593055cbb4bd32c?ref=oh-3.35.7-dev&prId=772)
- 解决了 3.35 版本中测试字段键盘无法缩回的问题[cdaa2f61](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/cdaa2f611f31952d7c58228a81267660e8f91e51?ref=oh-3.35.7-dev&prId=772)
- 解决在剪切操作后无法进行粘贴的问题[d3ddc4e0](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/d3ddc4e0e361c9294ab4d2fd3a43768ea58dae8a?ref=fix_pasting&prId=803)
- 修复ohos平台运行build命令，无法生成指定的文件夹[31d92a8c](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/31d92a8c25389ad554c9f01b6f3176032b68b8d9?ref=oh-3.35.7-dev&prId=797)
- 解决了在AndroidStudio 上某些断点无法断住的问题[c4ae8eff](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/c4ae8eff5d0b41b9ccd6a81ccf026bd02c9c107d?ref=start_paused&prId=820)