import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';

// import 'package:dio/adapter_browser.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

typedef onRequestSuccess<T> = Function(Response<T> response);
typedef onRequestFail = Function(String error);
typedef onGetResponseData<T> = Function(T response);

class HttpGo {
  static final StringGET = "get";

  static final StringPOST = "post";

  static final StringDATA = "data";

  static final StringCODE = "errorCode";

  String base_url = "";

  late Dio dio;

  static HttpGo? instance;

  BaseOptions? options;

  Map<String, dynamic> heads = new Map();

  static HttpGogetInstance({String baseUrl = ""}) {
    if (instance == null) {
      instance = HttpGo(baseUrl: baseUrl);
    }
    return instance;
  }

  void setOptions(BaseOptions options) {
    this.options = options;
    dio.options = this.options!;
  }

  HttpGo({baseUrl}) {
//BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    base_url = baseUrl;
    options = new BaseOptions(
//请求基地址,可以包含子路径

      baseUrl: baseUrl ?? base_url,

      //连接服务器超时时间，单位是毫秒.

      connectTimeout: 50000,

      //响应流上前后两次接受到数据的间隔，单位为毫秒。

      receiveTimeout: 100000,

      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")

//      contentType: ContentType.parse("application/x-www-form-urlencoded"),
//       contentType: Headers.formUrlEncodedContentType,
      contentType: Headers.formUrlEncodedContentType,
//      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是`json`,

      responseType: ResponseType.json,
    );

    dio = Dio(options);

//    dio.interceptors.add(CookieManager(CookieJar()));
    setCookie();
    //添加拦截器
  }

  void addInterceptor(InterceptorsWrapper wrapper) {
    dio.interceptors.add(wrapper);
  }

  ///设置cookie
  void setCookie() async {
    // 获取文档目录的路径
    if (kIsWeb) {
      // var cookieJar = PersistCookieJar();
      // dio.interceptors.add(CookieManager(cookieJar));
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dir = appDocDir.path + "/.cookies/";
      var cookieJar = PersistCookieJar(storage: FileStorage(dir));
      dio.interceptors.add(CookieManager(cookieJar));
    }
  }

/*

  * get请求*/

  void setProxy(String host, int port, bool ignoreCer) {
    if (kIsWeb) {
      return;
    }
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (url) {
        return "PROXY ${host}:${port.toString()}";
      };

      if (ignoreCer) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      }
    };
  }

/*

  * post请求*/

  void post<T>(url,
      {data,
      options,
      cancelToken,
      onRequestSuccess<T>? successListener,
      onRequestFail? errorListener}) async {
    try {
      Response<T> response = await dio.post<T>(url,
          data: data, options: options, cancelToken: cancelToken);

      successListener!(response);
    } catch (e) {
      debugPrint('post error---------${e.toString()}');
      errorListener!(formatError(e));
    }
  }

  Future<Map> postData(
    url, {
    data,
    options,
    cancelToken,
  }) async {
    var response = await dio.post<Map>(url,
        data: data, options: options, cancelToken: cancelToken);
    return Future.value(response.data);
  }

  Future<Map> getData(url,{
    data,
    options,
    cancelToken,
  }) async {
    Response<Map> response = await dio.get<Map>(url,
        queryParameters: data, options: options, cancelToken: cancelToken);
    return Future.value(response.data);
  }

  void get<T>(url,
      {data,
      options,
      cancelToken,
      onRequestSuccess<T>? successListener,
      onRequestFail? errorListener}) async {
    try {
      Response<T> response = await dio.get<T>(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      successListener!(response);
    } catch (e) {
      debugPrint('get error---------$e');
      errorListener!(formatError(e));
    }
  }

/*

  * 下载文件*/

  void downloadFile(
      urlPath, savePath, onReceiveProgress, onRequestFail errorListener) async {
    try {
      Response response = await Dio()
          .download(urlPath, savePath, onReceiveProgress: onReceiveProgress);
    } catch (e) {
      errorListener(formatError(e));
    }
  }

/*

  * error统一处理*/

  String formatError(e) {
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout) {
// It occurs when url is opened timeout.

        return "连接超时";
      } else if (e.type == DioErrorType.sendTimeout) {
// It occurs when url is sent timeout.

        return "请求超时";
      } else if (e.type == DioErrorType.receiveTimeout) {
//It occurs when receiving timeout

        return "响应超时";
      } else if (e.type == DioErrorType.response) {
// When the server response, but with a incorrect status, such as 404, 503...
        return checkError(e.message);
      } else if (e.type == DioErrorType.cancel) {
// When the request is cancelled, dio will throw a error with this type.
        return "";
      } else if (e.type == DioErrorType.other) {
        return e.message;
      } else {
//DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
        return "未知错误";
      }
    } else {
      return "未知错误";
    }
  }

  String checkError(String message) {
    if (message.contains("404")) {
      return "【404】调用方法未找到";
    } else if (message.contains("500")) {
      return "【500】服务器发生异常";
    } else if (message.contains("503")) {
      return "【503】服务器发生异常";
    } else {
      return message;
    }
  }

/*

  * 取消请求*

  * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。  * 所以参数可选*/

  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}

String RequestParamsStr(Map<String, Object> value) {
  return "json=${json.encode(value)}";
}

Map<String, dynamic> RequestParams(Map<String, dynamic> value) {
  return {"json": json.encode(value)};
//  return "json=${json.encode(value)}";
}

Map<String, dynamic> RequestParamsWithKey(
    String key, Map<String, Object> value) {
  return {key: json.encode(value)};
//  return "json=${json.encode(value)}";
}
