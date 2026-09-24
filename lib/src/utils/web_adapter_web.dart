import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

///web 平台：替换为浏览器 XHR 适配器，启用跨域 Cookie 能力。
///
///[withCredentials] 开启后，跨域请求会携带 / 接收 Cookie，
///要求后端返回 `Access-Control-Allow-Credentials: true`
///且 `Access-Control-Allow-Origin` 为具体源（不能是 `*`），否则请求会被浏览器拦截。
void applyBrowserAdapter(Dio dio, {required bool withCredentials}) {
  dio.httpClientAdapter = BrowserHttpClientAdapter(
    withCredentials: withCredentials,
  );
}
