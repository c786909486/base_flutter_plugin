import 'package:flutter/material.dart';

void setupLocator(){
NavigateService.getInstance();
}

class NavigateService {

  static NavigateService _instance;

  static NavigateService getInstance(){
    if(_instance ==null){
      _instance = NavigateService();
    }
    return _instance;
  }

  final GlobalKey<NavigatorState> key = GlobalKey();

  NavigatorState get navigator => key.currentState;

  get pushNamed => navigator?.pushNamed;
  get push =>  navigator?.push;
  get pushReplacement =>navigator?.pushReplacement;
  get pop =>navigator?.pop;
}