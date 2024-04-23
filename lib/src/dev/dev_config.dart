import 'dart:async';

import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/cupertino.dart';

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


  void init() {
    inDevModel = SpUtil.getBool("inDevModel", defValue: false) ?? false;
    canProxy = SpUtil.getBool("canProxy", defValue: false) ?? false;
    host = SpUtil.getString("host", defValue: "") ?? "";
    port = SpUtil.getInt("port", defValue: 0) ?? 0;
    print("11111111");
    if (canProxy) {
      HttpGo.instance.setProxy(host, port, true);
      print("2222222");
    } else {
      HttpGo.instance.closeProxy(ignoreCer: true);
      print("3333333");
    }
  }

  ///设置代理
  Future<void> saveProxy({
    bool canProxy = false,
    String host = "",
    int port = 0,
  }) async {
    // this.canProxy = canProxy;
    // this.host = host;
    // this.port = port;
    await SpUtil.putBool("canProxy", canProxy);
    await SpUtil.putString("host", host);
    await SpUtil.putInt("port", port);
    // if (canProxy) {
    //   HttpGo.instance.setProxy(host, port, true);
    // } else {
    //   HttpGo.instance.closeProxy(ignoreCer: true);
    // }
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
        var tick = timer.tick;
        print("currentTick===>${tick}");
        if(tick==5){
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
}
