import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetErrorUtils {
  static Function(dynamic error)? netStr;

  static void initErrorFormat(Function(dynamic error) str) {
    netStr = str;
  }

  ///获取网络错误的用户可读文案。
  ///
  ///优先使用 [initErrorFormat] 注册的自定义格式化；
  ///否则走内置实现，保证 native / web 行为一致
  ///（不再依赖上游 `HttpGo.formatError`，它在 web 上会把
  ///连接错误误报为“未知错误”）。
  static String getNetError(dynamic error) {
    return netStr == null ? format(error) : netStr!(error);
  }

  ///统一错误文案（native / web 通用）
  static String format(dynamic error) {
    if (error is DioException) {
      return _formatDioException(error);
    }
    if (error is String) {
      return error;
    }
    if (error is FormatException) {
      //web 上网关 / 错误页常返回 HTML，jsonDecode 会抛到这里
      return "数据解析失败：返回内容不是合法 JSON";
    }
    if (error is TypeError) {
      return "数据解析失败";
    }
    return "网络连接失败，请检查网络";
  }

  static String _formatDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "连接超时";
      case DioExceptionType.sendTimeout:
        return "请求超时";
      case DioExceptionType.receiveTimeout:
        return "响应超时";
      case DioExceptionType.cancel:
        //取消不打扰用户，与上游约定保持一致
        return "";
      case DioExceptionType.connectionError:
        //native 断网与 web 的“连不上 / 域名解析失败”都会归到这个类型，
        //上游 formatError 漏掉了此分支，会误报“未知错误”
        return "网络连接失败，请检查网络";
      case DioExceptionType.badResponse:
        return _formatStatusCode(e.response?.statusCode, e.message ?? "");
      case DioExceptionType.badCertificate:
        return "证书校验失败";
      case DioExceptionType.unknown:
        return _formatUnknown(e);
      default:
        return "未知错误";
    }
  }

  static String _formatStatusCode(int? statusCode, String fallback) {
    if (statusCode == 404) {
      return "【404】请求地址不存在";
    }
    if (statusCode == 401) {
      return "【401】未登录或登录已失效";
    }
    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      return "【$statusCode】服务器发生异常";
    }
    if (statusCode != null) {
      return "【$statusCode】请求失败";
    }
    return fallback.isEmpty ? "网络连接失败，请检查网络" : fallback;
  }

  static String _formatUnknown(DioException e) {
    final message = e.message ?? "";
    //web 上断网 / CORS 被拦截 / 服务不可达，浏览器统一表现为
    //XMLHttpRequest 层错误（message 为英文且对用户无意义）
    final isBrowserNetError = message.contains("XMLHttpRequest") ||
        message.contains("onError callback") ||
        message.contains("Failed to fetch") ||
        message.contains("NetworkError") ||
        message.contains("CORS");
    if (isBrowserNetError) {
      return kDebugMode
          ? "网络连接失败（请检查网络，或后端是否配置了 CORS 跨域）"
          : "网络连接失败，请检查网络";
    }
    //其余未知错误保留原始信息，便于排查
    return message.isEmpty ? "网络连接失败，请检查网络" : message;
  }
}
