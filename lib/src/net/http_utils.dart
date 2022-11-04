import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:base_flutter/base_flutter.dart';

typedef onRequestSuccess<T> = Function(Response<T> response);
typedef onRequestFail = Function(String error);
typedef onGetResponseData<T> = Function(T response);

class HttpGo {

  String base_url = "";

  Dio? dio;

  static HttpGo? _instance;

  static HttpGo get instance => _instance ?? HttpGogetInstance();

  BaseOptions? options;

  Map<String, dynamic> heads = new Map();

  static HttpGogetInstance({String baseUrl = ""}) {
    if (_instance == null) {
      _instance = HttpGo(baseUrl: baseUrl);
    }
    return _instance;
  }

  void setOptions(BaseOptions options) {
    this.options = options;
    dio?.options = this.options!;
  }

  HttpGo({baseUrl}) {
//BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    base_url = baseUrl;
    options = new BaseOptions(
//请求基地址,可以包含子路径

      baseUrl: base_url,

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
    _initDio();
    //添加拦截器
    // setCookie();
  }

  void _initDio() {
    Interceptors? interceptors;
    if (dio != null) {
      interceptors = dio!.interceptors;
    }
    dio = Dio(options);
    if (interceptors != null) {
      dio!.interceptors.addAll(interceptors);
    }

//    dio.interceptors.add(CookieManager(CookieJar()));

  }

  void addInterceptor(InterceptorsWrapper wrapper) {
    dio?.interceptors.add(wrapper);
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
      dio?.interceptors.add(CookieManager(cookieJar));
    }
  }

/*

  * get请求*/

  void setProxy(String host, int port, bool ignoreCer) {
    if (kIsWeb) {
      return;
    }
    _initDio();
    (dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (url) {
        return host.isNotEmpty ? "PROXY ${host}:${port.toString()}" : "DIRECT";
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
      Response<T> response = await dio!.post<T>(url,
          data: data, options: options, cancelToken: cancelToken);

      successListener!(response);
    } catch (e) {
      debugPrint('post error---------${e.toString()}');
      errorListener!(formatError(e));
    }
  }

  Future<Map> request(String url, {
    data,
    Map<String, dynamic>? queryParameters,
    String method = "get",
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try{
      var response = await dio!.request(url, data: data,
          options: Options(
              method: method,
              receiveTimeout: options?.receiveTimeout,
              sendTimeout: options?.sendTimeout,
              extra: options?.extra,
              headers: options?.headers,
              responseType: options?.responseType,
              contentType: options?.contentType,
              validateStatus: options?.validateStatus,
              receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
              followRedirects: options?.followRedirects,
              maxRedirects: options?.maxRedirects,
              requestEncoder: options?.requestEncoder,
              responseDecoder: options?.responseDecoder,
              listFormat: options?.listFormat
          ),
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      if (response.data is String) {
        return response.data.toString().toMap();
      } else {
        return response.data;
      }
    }catch (e) {
      throw e;
    }
  }

  Future<Map> postData(String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.post(url,
          data: data,
          options: options,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      if (response.data is String) {
        return response.data.toString().toMap();
      } else {
        return response.data;
      }
    } catch (e) {
      throw e;
    }
  }


  Future<Map> getData(url, {
    data,
    options,
    cancelToken,
  }) async {
    try {
      Response response = await dio!.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      if (response.data is String) {
        return response.data.toString().toMap();
      } else {
        return response.data;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String> getDataString(url, {
    data,
    options,
    cancelToken,
  }) async {
    try {
      Response response = await dio!.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      return response.data.toString();
    } catch (e) {
      throw e;
    }
  }

  void get<T>(url,
      {data,
        options,
        cancelToken,
        onRequestSuccess<T>? successListener,
        onRequestFail? errorListener}) async {
    try {
      Response<T> response = await dio!.get<T>(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      successListener!(response);
    } catch (e) {
      debugPrint('get error---------$e');
      errorListener!(formatError(e));
    }
  }

/*

  * 下载文件*/

  void downloadFile(urlPath, savePath, onReceiveProgress,
      onRequestFail errorListener) async {
    try {
      Response response = await Dio()
          .download(urlPath, savePath, onReceiveProgress: onReceiveProgress);
    } catch (e) {
      errorListener(formatError(e));
    }
  }

/*

  * error统一处理*/

  static String formatError(e) {
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout) {
        return "连接超时";
      } else if (e.type == DioErrorType.sendTimeout) {
        return "请求超时";
      } else if (e.type == DioErrorType.receiveTimeout) {
        return "响应超时";
      } else if (e.type == DioErrorType.response) {
        return checkError(e.message);
      } else if (e.type == DioErrorType.cancel) {
        return "";
      } else if (e.type == DioErrorType.other) {
        return e.message;
      } else {
        return "未知错误";
      }
    } else {
      if(e is String){
        return e;
      }else if(e is HttpException){
        return "网络连接失败，请检查网络";
      }else {
        return "网络连接失败，请检查网络";
      }
    }
  }

  static String checkError(String message) {
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

Map<String, dynamic> RequestParamsWithKey(String key,
    Map<String, Object> value) {
  return {key: json.encode(value)};
//  return "json=${json.encode(value)}";
}
