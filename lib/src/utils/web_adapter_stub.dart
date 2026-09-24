import 'package:dio/dio.dart';

///非 web 平台占位实现：IOHttpClientAdapter 无需替换。
void applyBrowserAdapter(Dio dio, {required bool withCredentials}) {
  //no-op
}
