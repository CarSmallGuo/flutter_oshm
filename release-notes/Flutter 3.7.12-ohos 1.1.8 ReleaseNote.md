## 版本概述
本版本为基于Flutter 3.7.12适配的OpenHarmony版本。本版本支持和完善OpenHarmony平台侧能力，提升稳定性。

## 新增特性
- 增加copyResource方法中的异常捕获，增加try catch及异常日志

## Bug修复
- 分屏时在应用间输入框焦点相互切换，切至flutter输入字符后候选词显示位置有误
- 解决attach异步以及多输入框候选词跟随的问题
- 优化候选词位置为光标的右下角，修改获取坐标方式
- 修复多个flutterview情况下，鼠标和手势事件分发错误的问题
- 解决上下分屏打开固定态软键盘后切换左右分屏页面上缩问题
- 修复flutter3.7编译的release应用无法在windows模拟器上运行的问题
- 使用原子变量解决外接纹理设置pixelmap时线程冲突的问题
- 修复3.7Channel内存泄漏问题

## 版本发布时间
2025年12月25日

## 版本配套
- OpenHarmony API20
- Flutter SDK: 3.7.12-ohos-1.1.8

## Changelog
- [6.0.3.21, 6.0.3.20, 6.0.3.17, 6.0.2.122, 6.0.2.121](../CHANGELOG.md)

## 赋能文档
- [文档链接](https://gitcode.com/openharmony-tpc/flutter_samples/tree/master/ohos/docs)