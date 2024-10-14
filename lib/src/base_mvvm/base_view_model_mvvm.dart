import 'package:base_flutter/src/message/message_event.dart';
import 'package:flutter/cupertino.dart';

import '../../base_flutter.dart';
import 'base_model_mvvm.dart';

typedef EventPostMethodWithMsg(String msg);
typedef EventPostMethod();
typedef EventPostMethodWithData(dynamic data);


abstract class BaseViewModel with ChangeNotifier {

  List<BaseMvvmModel> _models = [];

  BuildContext? _context;

  bool mounted = false;

  BaseViewModel(this._context){
    mounted = true;
    init();
  }

  void init(){

  }

  get context => _context;



  void addModel(BaseMvvmModel model){
    _models.add(model);
  }

  void addModels(List<BaseMvvmModel> models){
    _models.addAll(models);
  }

  ///toast事件
  EventPostMethodWithMsg? _toastEvent;

  ///加载弹窗事件
  EventPostMethodWithMsg? _showDialogEvent;

  ///关闭弹窗事件
  EventPostMethod? _hideDialogEvent;

  ///显示加载页面
  EventPostMethod? _showLoadingEvent;

  ///显示错误页面
  EventPostMethodWithMsg? _showErrorEvent;

  ///显示空页面
  EventPostMethodWithMsg? _showEmptyEvent;

  ///显示正文内容
  EventPostMethod? _showContent;

  ///结束刷新事件
  EventPostMethod? _finishRefreshEvent;

  ///结束加载更多事件
  EventPostMethod? _finishLoadMoreEvent;

  ///关闭页面事件
  EventPostMethodWithData? _finishEvent;

  EventPostMethodWithData? _sendMessageEvent;

  LoadingState? loadingState = LoadingState.showContent;


  void addBaseEvent({
    EventPostMethodWithMsg? toastEvent,
    EventPostMethodWithMsg? showDialogEvent,
    EventPostMethod? hideDialogEvent,
    EventPostMethod? showLoadingEvent,
    EventPostMethodWithMsg? showErrorEvent,
    EventPostMethodWithMsg? showEmptyEvent,
    EventPostMethod? showContent,
    EventPostMethod? finishRefreshEvent,
    EventPostMethod? finishLoadMoreEvent,
    EventPostMethodWithData? finishEvent,
    EventPostMethodWithData? sendMessageEvent,
  }) {
    this._toastEvent = toastEvent;
    this._showDialogEvent = showDialogEvent;
    this._hideDialogEvent = hideDialogEvent;
    this._showLoadingEvent = showLoadingEvent;
    this._showErrorEvent = showErrorEvent;
    this._showEmptyEvent = showEmptyEvent;
    this._finishRefreshEvent = finishRefreshEvent;
    this._finishLoadMoreEvent = finishLoadMoreEvent;
    this._showContent = showContent;
    this._finishEvent = finishEvent;
    this._sendMessageEvent = sendMessageEvent;
  }

  void showToast(String msg) {
    if(mounted){
      _toastEvent!(msg);
    }
  }

  void showLoadingDialog({String msg = "加载中..."}){
    if(mounted){
      _showDialogEvent!(msg);
    }
  }

  void hideDialog(){
    if(mounted){
      _hideDialogEvent!();
    }
  }

  void showLoadingState(){
    if(mounted){
      _showLoadingEvent!();
    }
  }

  void showErrorState(String error){
    if(mounted){
      _showErrorEvent!(error);
    }
  }

  void showEmptyState({String msg = "暂无数据"}){
    if(mounted){
      _showEmptyEvent!(msg);
    }
  }

  void finishRefresh(){
    _finishRefreshEvent!();
  }

  void finishLoadMore(){
   if(mounted){
     _finishLoadMoreEvent!();
   }
  }

  void showContent(){
    if(mounted){
      _showContent!();
    }
  }

  void finish({dynamic data}){
   if(mounted){
     _finishEvent!(data);
   }
  }

  void sendMessage(SendMessageEvent event){
   if(mounted){
     _sendMessageEvent!(event);
   }
  }


  ///销毁model
  void onDispose(){
    mounted = false;
    for(BaseMvvmModel model in _models){
      model.onCleared();
    }
    _models.clear();
    _release();
    
  }

  void _release(){
    _context = null;
    _toastEvent = null;
    _showDialogEvent = null;
    _hideDialogEvent = null;
    _showLoadingEvent = null;
    _showErrorEvent = null;
    _showEmptyEvent = null;
    _showContent = null;
    _finishRefreshEvent = null;
    _finishLoadMoreEvent = null;
    _finishEvent = null;
    _sendMessageEvent = null;
    loadingState = null;
  }

  void onCreated(){

  }

  void onResume(){

  }

  void onPause(){

  }

  ///加载弹窗关闭时调用
  void onDialogDismiss(){}

  void receiveMessage(SendMessageEvent event){

  }



}