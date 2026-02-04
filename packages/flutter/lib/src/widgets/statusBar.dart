// Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'package:flutter/services.dart';

class ChannelMessageHandler {
  static const MethodChannel _channel = MethodChannel('flutter/statusBarClick');

  static bool isInit = false;
  static DateTime? lastCallTime;

  // 使用广播流控制器允许多个监听者
  static final StreamController<dynamic> _streamController =
      StreamController<dynamic>.broadcast();

  // 初始化Channel处理器
  static void init() {
    if (isInit) {
      return;
    }
    isInit = true;
    _channel.setMethodCallHandler((call) async {
      throttle(() {
        _streamController.add({
        'method': call.method,
        'arguments': call.arguments,
      });
      }, const Duration(milliseconds: 1000));
    });
  }

  static throttle(Function() callback, Duration duration) {
    final now = DateTime.now();
    if (lastCallTime == null || now.difference(lastCallTime!) >= duration) {
      lastCallTime = now;
      callback();
    }
  }

  // 获取消息流供组件订阅
  static Stream<dynamic> get messageStream => _streamController.stream;

  // 关闭流控制器
  static void dispose() {
    _streamController.close();
  }
}
