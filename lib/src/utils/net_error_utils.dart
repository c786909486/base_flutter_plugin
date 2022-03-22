class NetErrorUtils {
  static Function(dynamic error)? netStr;

  static void initErrorFormat(Function(dynamic error) str) {
    netStr = str;
  }

  static String getNetError(dynamic error) {
    return netStr == null ? error.toString() : netStr!(error);
  }
}
