import 'package:dio_net_work/dio_net_work.dart';
import 'package:flutter/foundation.dart';

import 'web_adapter_stub.dart'
    if (dart.library.js_interop) 'web_adapter_web.dart' as web_adapter;

///网络层平台能力封装（web 适配入口）。
///
///用法：在 `runApp` 之前调用一次
///```dart
///void main() {
///  NetPlatform.init(); //需要跨域带 cookie 时：NetPlatform.init(withCredentials: true)
///  runApp(MyApp());
///}
///```
///非 web 平台所有方法均为空操作。
class NetPlatform {
  NetPlatform._();

  static bool _inited = false;

  ///web 端是否启用了跨域携带 Cookie（仅 web 有意义）
  static bool withCredentials = false;

  ///应用级网络初始化，建议在 runApp 前调用。
  ///
  ///[withCredentials]：仅 web 生效。跨域请求携带 / 接收 Cookie。
  ///开启前提：后端返回 `Access-Control-Allow-Credentials: true`，
  ///且 `Access-Control-Allow-Origin` 是具体源（不能是 `*`），
  ///否则跨域请求会被浏览器直接拦截（表现为“网络连接失败”）。
  static void init({bool withCredentials = false}) {
    if (!kIsWeb || _inited) return;
    _inited = true;
    NetPlatform.withCredentials = withCredentials;
    final dio = HttpGo.instance.dio;
    if (dio != null) {
      web_adapter.applyBrowserAdapter(dio, withCredentials: withCredentials);
    }
  }
}
