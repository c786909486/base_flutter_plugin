import 'package:flutter/cupertino.dart';

typedef OnPageStartEndListener = Function(
    String pageName, String pageTitle, Widget page);

typedef OnPageChangeListener = Function(List<Widget> pages);

class AppLifeUtils {
  static AppLifeUtils? _instance;

  static AppLifeUtils get instance {
    if (_instance == null) {
      _instance = AppLifeUtils._();
    }
    return _instance!;
  }

  AppLifeUtils._();

  OnPageStartEndListener? _onStartListener;
  OnPageStartEndListener? _onCloseListener;
  OnPageChangeListener? _onPageChangeListener;

  var _widgetList = <Widget>[];

  void openPage(String pageName, String pageTitle, Widget page) {
    _widgetList.add(page);
    if (_onStartListener != null) {
      _onStartListener!(pageName, pageTitle, page);
    }
    if(_onPageChangeListener!=null){
      _onPageChangeListener!(_widgetList);
    }
  }

  void closePage(String pageName, String pageTitle, Widget page) {
    _widgetList.remove(page);
    if (_onCloseListener != null) {
      _onCloseListener!(pageName, pageTitle, page);
    }
    if(_onPageChangeListener!=null){
      _onPageChangeListener!(_widgetList);
    }
  }
}
