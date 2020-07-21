import 'package:flutter/cupertino.dart';

typedef EventPostMethodWithMsg(String msg);
typedef EventPostMethod();


abstract class BaseViewModel with ChangeNotifier {

  ///toast事件
  EventPostMethodWithMsg _toastEvent;

  ///加载弹窗事件
  EventPostMethodWithMsg _showDialogEvent;

  ///关闭弹窗事件
  EventPostMethod _hideDialogEvent;

  ///显示加载页面
  EventPostMethod _showLoadingEvent;

  ///显示错误页面
  EventPostMethodWithMsg _showErrorEvent;

  ///显示空页面
  EventPostMethod _showEmptyEvent;

  EventPostMethod _showContent;

  ///结束刷新事件
  EventPostMethod _finishRefreshEvent;

  ///结束加载更多事件
  EventPostMethod _finishLoadMoreEvent;

  void addBaseEvent({
    EventPostMethodWithMsg toastEvent,
    EventPostMethodWithMsg showDialogEvent,
    EventPostMethod hideDialogEvent,
    EventPostMethod showLoadingEvent,
    EventPostMethodWithMsg showErrorEvent,
    EventPostMethod showEmptyEvent,
    EventPostMethod showContent,
    EventPostMethod finishRefreshEvent,
    EventPostMethod finishLoadMoreEvent}) {
    this._toastEvent = toastEvent;
    this._showDialogEvent = showDialogEvent;
    this._hideDialogEvent = hideDialogEvent;
    this._showLoadingEvent = showLoadingEvent;
    this._showErrorEvent = showErrorEvent;
    this._showEmptyEvent = showEmptyEvent;
    this._finishRefreshEvent = finishRefreshEvent;
    this._finishLoadMoreEvent = finishLoadMoreEvent;
    this._showContent = showContent;
  }

  void showToast(String msg) {
    _toastEvent(msg);
  }

  void showDialog({String msg = "加载中。。。"}){
    _showDialogEvent(msg);
  }

  void hideDialog(){
    _hideDialogEvent();
  }

  void showLoadingState(){
    _showLoadingEvent();
  }

  void showErrorState(String error){
    _showErrorEvent(error);
  }


  void showEmptyState(){
    _showEmptyEvent();
  }

  void finishRefresh(){
    _finishRefreshEvent();
  }

  void finishLoadMore(){
    _finishLoadMoreEvent();
  }

  void showContent(){
    _showContent();
  }
}