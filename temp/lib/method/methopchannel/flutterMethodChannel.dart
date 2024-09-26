import 'package:flutter/services.dart';

// MethodChannel
const methodChannel = const MethodChannel('samples.flutter.dev/test');

class FlutterMethodChannel {
  /*
   * MethodChannel
   * 在方法通道上调用方法invokeMethod
   * methodName 方法名称
   * params 发送给原生的参数
   * return数据 原生发给Flutter的参数
   */
  static Future<Map> invokeNativeMethod(String methodName, [Map? params]) async {
    var res;
    try {
      if (params == null) {
        res = await methodChannel.invokeMethod(methodName);
      } else {
        res = await methodChannel.invokeMethod(methodName, params);
      }
    } catch (e) {
      res = {'Failed': e.toString()};
    }

    // 将结果包装成Map类型
    if (res is String) {
      return {'message': res};
    } else if (res is Map) {
      return res;
    } else {
      return {'UnexpectedType': res.toString()};
    }
  }

  /*
   * MethodChannel
   * 接收methodHandler
   * methodName 方法名称
   * params 发送给原生的参数
   * return数据 原生发给Flutter的参数
   */
  static void methodHandlerListener(Future<dynamic> Function(MethodCall call)? handler) {
    methodChannel.setMethodCallHandler(handler);
  }
}
