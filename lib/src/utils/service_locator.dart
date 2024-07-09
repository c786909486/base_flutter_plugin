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

  NavigatorState get navigator => key.currentState!;

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
    if((route is CupertinoPageRoute || route is MaterialPageRoute)){
      String? routerName = previousRoute?.settings.name;
      if(routerName != null){
        StateLifecycleManager.instance.onResume(routerName);
      }
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if((route is CupertinoPageRoute || route is MaterialPageRoute)){
      String? routerName = previousRoute?.settings.name;
      if(routerName != null){
        StateLifecycleManager.instance.onPause(routerName);
      }
    }
  }
}