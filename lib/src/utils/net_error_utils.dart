import 'package:base_flutter/base_flutter.dart';

class NetErrorUtils {
  static Function(dynamic error)? netStr;

  static void initErrorFormat(Function(dynamic error) str) {
    netStr = str;
  }

  static String getNetError(dynamic error) {
    return netStr == null ? HttpGo.formatError(error) : netStr!(error);
  }
}
