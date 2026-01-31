import 'dart:async';
import 'package:flutter/services.dart';

class ChannelMessageHandler {
  static const MethodChannel _channel = MethodChannel('flutter/statusBarClick');

  static bool isInit = false;

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
      print('Received method call: ${call.method} with arguments: ${call.arguments}');
      // 将接收到的消息广播给所有订阅者
      _streamController.add({
        'method': call.method,
        'arguments': call.arguments,
      });
    });
  }

  // 发送消息到原生端
  // static Future<void> sendMessage(String message) async {
  //   try {
  //     await _channel.invokeMethod('sendMessage', {'text': message});
  //   } on PlatformException catch (e) {
  //     print("Failed to send message: '${e.message}'.");
  //   }
  // }

  // 获取消息流供组件订阅
  static Stream<dynamic> get messageStream => _streamController.stream;

  // 关闭流控制器
  static void dispose() {
    _streamController.close();
  }
}
