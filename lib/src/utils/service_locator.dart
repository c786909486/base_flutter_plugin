import 'package:flutter/material.dart';

void setupLocator(){
NavigateService.getInstance();
}

class NavigateService {

  static NavigateService instance;

  static NavigateService getInstance(){
    if(instance ==null){
      instance = NavigateService();
    }
    return instance;
  }

  final GlobalKey<NavigatorState> key = GlobalKey();

  NavigatorState get navigator => key.currentState;

  get pushNamed => navigator.pushNamed;
  get push =>  navigator.push;
  get pushReplacement =>navigator.pushReplacement;
  get pop =>navigator.pop;
}