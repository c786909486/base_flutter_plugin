
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BaseRouteUtils {

  Widget? createRoute(String name, {dynamic params});

  intentTo(String name, {params, RouteSettings? settings, bool maintainState = true, bool fullscreenDialog = false}) {
    return NavigateService.getInstance().navigator.push( MaterialPageRoute(builder: (context){
      return createRoute(name,params: params)!;
    },settings: settings,maintainState: maintainState,fullscreenDialog: fullscreenDialog));
  }

  push(Widget page,{params, RouteSettings? settings, bool maintainState = true, bool fullscreenDialog = false}){
    return NavigateService.getInstance().navigator.push( MaterialPageRoute(builder: (context){
      return page;
    },settings: settings,maintainState: maintainState,fullscreenDialog: fullscreenDialog));
  }

  pushAndPop(Widget page, {params, RouteSettings? settings, result}) {
    return NavigateService.getInstance().navigator.pushReplacement(MaterialPageRoute(builder: (context){
      return page;
    }),result: result);
  }

  pushReplacement(String name, {params, RouteSettings? settings, result}) {
    return NavigateService.getInstance().navigator.pushReplacement(MaterialPageRoute(builder: (context){
      return createRoute(name,params: params)!;
    }),result: result);
  }

  pop({result}) {
    return NavigateService.getInstance().navigator.pop(result);
  }

  pushAndRemoveUntil(String name,{params}){
    return NavigateService.getInstance().navigator.pushAndRemoveUntil(new MaterialPageRoute(
      builder: (BuildContext context) {
        return createRoute(name,params: params)!;
      },
    ), (route) => route == null);
  }
}

class CustomNavigatorObserver extends NavigatorObserver{

  static CustomNavigatorObserver? _instance;

  static CustomNavigatorObserver? getInstace(){
    if(_instance == null){
      _instance = CustomNavigatorObserver();
    }
    return _instance;
  }
}
