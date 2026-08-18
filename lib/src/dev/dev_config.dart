import 'dart:async';
import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/dev/network_record_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevConfig {
  static DevConfig? _instance;

  static DevConfig get instance => _instance ??= DevConfig();

  ///是否开发者模式
  bool inDevModel = false;

  ///是否开启代理
  bool canProxy = false;

  ///代理host
  String host = "";

  ///代理端口
  int port = 0;
  
  ///是否开启抓包
  bool canGetNetRequest = false;


  void init() {
    inDevModel = SpUtil.getBool("inDevModel", defValue: false) ?? false;
    canProxy = SpUtil.getBool("canProxy", defValue: false) ?? false;
    canGetNetRequest = SpUtil.getBool("canGetNetRequest", defValue: false) ?? false;
    host = SpUtil.getString("host", defValue: "") ?? "";
    port = SpUtil.getInt("port", defValue: 0) ?? 0;
    if (canProxy) {
      HttpGo.instance.setProxy(host, port, true);
    } else {
      HttpGo.instance.closeProxy(ignoreCer: true);
    }
  }

  // 添加一个变量来存储悬浮窗位置
  Offset _offset = Offset(0, 100);

  ///拖动时的位置通知器：拖动只更新Transform，避免重建整个overlay子树
  final ValueNotifier<Offset> _floatingOffset = ValueNotifier(Offset(0, 100));

  OverlayEntry? overlayEntry;
  void addNetFloating(BuildContext context) {
    if(overlayEntry != null) {
      overlayEntry?.remove();
      networkRecords.clear();
      overlayEntry = null;
    }
    if(!canGetNetRequest) {
      return;
    }
    _floatingOffset.value = _offset;

    overlayEntry = OverlayEntry(builder: (context) {
      return ValueListenableBuilder<Offset>(
        valueListenable: _floatingOffset,
        builder: (context, offset, _) {
          return Positioned(
            left: 0,
            top: 0,
            child: Transform.translate(
              offset: offset,
              child: GestureDetector(
                // 在 overlayEntry 的 GestureDetector 中修改 onTap
                onTap: () {

                  // 检查当前路由栈中是否已经存在 NetworkRecordPage
                  bool isRecordPageOpen = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == 'network_record_page') {
                      isRecordPageOpen = true;
                      return true;
                    }
                    return true;
                  });

                  if (!isRecordPageOpen) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name: 'network_record_page'),
                        builder: (context) => NetworkRecordPage.instance,
                      ),
                    );
                  }
                },
                onPanUpdate: (details) {
                  _floatingOffset.value += details.delta;
                },
                onPanEnd: (details) {
                  // 获取屏幕尺寸
                  final size = MediaQuery.of(context).size;
                  double targetX = _floatingOffset.value.dx;

                  // 水平吸边
                  if (targetX < size.width / 2) {
                    targetX = 0; // 吸附到左边
                  } else {
                    targetX = size.width - 50; // 吸附到右边，50是悬浮窗宽度
                  }

                  // 确保不超出屏幕上下边界
                  double targetY = _floatingOffset.value.dy;
                  targetY = targetY.clamp(0, size.height - 50);

                  final target = Offset(targetX, targetY);
                  _floatingOffset.value = target;
                  _offset = target;
                },
                child: Material(
                  color: Colors.transparent,
                  // 在 addNetFloating 方法中的 Container 部分
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      shape: BoxShape.circle
                    ),
                    child: Text(
                      "${networkRecords.length}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    Overlay.of(context).insert(overlayEntry!);
    startRecordRequest();
  }

  // 存储网络请求记录
  static List<NetworkRecord> networkRecords = [];
  
  void startRecordRequest() {
    if (!canGetNetRequest) return;
    
    HttpGo.instance.dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final startTime = DateTime.now();
          options.extra['startTime'] = startTime;
          handler.next(options);
        },
        onResponse: (response, handler) {
          _recordNetwork(response, response.requestOptions);
          handler.next(response);
        },
        onError: (error, handler) {
          _recordNetwork(error.response, error.requestOptions);
          handler.next(error);
        },
      ),
    );
  }

  void _recordNetwork(Response? response, RequestOptions options) {
    final startTime = options.extra['startTime'] as DateTime;
    final duration = DateTime.now().difference(startTime);

    final record = NetworkRecord(
      timestamp: startTime,
      url: options.uri.toString(),
      method: options.method,
      headers: options.headers,
      requestBody: options.data,
      statusCode: response?.statusCode,
      responseBody: response?.data,
      duration: duration,
    );

    networkRecords.add(record);
    
    // 更新悬浮窗显示的请求数量
    if (overlayEntry != null) {
      overlayEntry?.markNeedsBuild();
    }
  }
  ///设置代理
  Future<void> saveProxy({
    bool canProxy = false,
    String host = "",
    int port = 0,
  }) async {
    await SpUtil.putBool("canProxy", canProxy);
    await SpUtil.putString("host", host);
    await SpUtil.putInt("port", port);
    init();
  }

  Timer? _timer;
  var count = 0;
  void openDevModel(BuildContext context){
    if(inDevModel){
      ToastUtils.shotToast("当前已经在开发者模式了", context: context);
      return;
    }
    count++;
    if(_timer==null){
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if(timer.tick==5){
          timer.cancel();
          _timer = null;
          count = 0;
        }else{
          if(count>=5){
            inDevModel = true;
            SpUtil.putBool("inDevModel", inDevModel);
          }
        }
      });

    }
  }
  static void clearNetworkRecords() {
    networkRecords.clear();
    instance.overlayEntry?.markNeedsBuild();
  }
}

class NetworkRecord {
  final DateTime timestamp;
  final String url;
  final String method;
  final Map<String, dynamic> headers;
  final dynamic requestBody;
  final int? statusCode;
  final dynamic responseBody;
  final Duration duration;

  NetworkRecord({
    required this.timestamp,
    required this.url,
    required this.method,
    required this.headers,
    required this.requestBody,
    this.statusCode,
    this.responseBody,
    required this.duration,
  });
}


