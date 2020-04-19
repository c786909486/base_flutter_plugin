//import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

//final GetIt getIt = GetIt.instance;
void setupLocator(){
//  getIt.registerSingleton(NavigateService());
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