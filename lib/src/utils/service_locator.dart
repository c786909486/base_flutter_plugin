import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_mvvm/page_life/page_life_circle_mixin.dart';

void setupLocator(){
NavigateService.getInstance();
}

class NavigateService {

  static NavigateService? _instance;

  static NavigateService getInstance(){
    if(_instance ==null){
      _instance = NavigateService();
    }
    return _instance!;
  }

  final GlobalKey<NavigatorState> key = GlobalKey();

  NavigatorState? _navigator;

  NavigatorState get navigator {
    // 缓存查找结果，避免每次调用currentState!重复查找
    return _navigator ??= key.currentState!;
  }

  get pushNamed => navigator.pushNamed;
  get push =>  navigator.push;
  get pushReplacement =>navigator.pushReplacement;
  get pop =>navigator.pop;
}

class StateNavigatorObserver extends NavigatorObserver {
  StateNavigatorObserver();

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if((route is CupertinoPageRoute || route is MaterialPageRoute || route is PageRoute)){
      Route? previous = previousRoute;
      if(previous != null){
        // 从其他页面回退回来：通知上一页恢复展示
        StateLifecycleManager.instance.onResumeByRoute(previous);
      }
    }
  }





  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if((route is CupertinoPageRoute || route is MaterialPageRoute || route is PageRoute)){
      Route? previous = previousRoute;
      if(previous != null){
        // 跳转到其他页面：通知上一页暂停展示
        StateLifecycleManager.instance.onPauseByRoute(previous);
      }
    }
  }
}