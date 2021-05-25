import 'dart:async';

import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/base_mvvm/base_view_model_mvvm.dart';
import 'package:base_flutter/src/base_mvvm/base_view_mvvm.dart';
import 'package:base_flutter/src/message/message_event.dart';
import 'package:base_flutter/src/widget/loading_view_plugin.dart';
import 'package:base_flutter/src/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lifecycle_state/flutter_lifecycle_state.dart';
import 'package:provider/provider.dart';


enum LoadingState{
  showContent,
  showError,
  showEmpty,
  showLoading
}

abstract class BaseStatefulMvvmWidget extends StatefulWidget {

  final Map<String,dynamic> params;

  const BaseStatefulMvvmWidget({Key key,this.params}):super(key:key);

}

abstract class BaseMvvmState<M extends BaseViewModel,W extends BaseStatefulMvvmWidget>
    extends StateWithLifecycle<W> implements IBaseMvvmView {
  M viewModel;

  LoadingViewPlugin _loadingViewPlugin;

  bool _isShowDialog = false;


  String pageError = "";


  StreamSubscription _subscription;

  LoadingState get currentState => viewModel.loadingState;

  @override
  void initState() {
    super.initState();

  }

  @override
  void onCreate() {
    super.onCreate();
    _loadingViewPlugin = LoadingViewPlugin(context);
    _subscription = eventBus.on<SendMessageEvent>().listen((event) {
      receiveMessage(event);
    });
  }

  void addLoadingWidget({Widget loadingWidget, Widget errorWidget, Widget emptyWidget}){
    _loadingViewPlugin.initWidget(loadingWidget: loadingWidget,errorWidget: errorWidget,emptyWidget: emptyWidget);
  }


  void receiveMessage(SendMessageEvent event){
    if(mounted&&viewModel!=null){
      viewModel.receiveMessage(event);
    }
  }




  @override
  Widget build(BuildContext context) {
    return initProvider() ;
  }

  Widget initProvider(){
    return ChangeNotifierProvider<M>(
      create: (_) {
        viewModel = createViewModel();
        Future.delayed(Duration(milliseconds: 1),(){
          onViewModelCreated();
        });
        return viewModel ;
      },
      child:Consumer<M>(builder: (_, provider, __) {
        viewModel = provider;
        _addBaseCallback();

        return buildRootView(context,createLoadingView());
      },),
    );
  }

  void _addBaseCallback(){
    viewModel.addBaseEvent(toastEvent: (msg) {
      if(mounted){
        showToast(msg);
      }
    },showDialogEvent: (msg){
      if(mounted){
        showLoadingDialog(msg);
      }
    },hideDialogEvent: (){
      if(mounted){
        hideDialog();
      }
    },showLoadingEvent: (){
      if(mounted){
        showLoading();
      }
    },showErrorEvent: (msg){
      if(mounted){
        showErrorPage(msg);
      }
    },showEmptyEvent: (){
     if(mounted){
       showEmpty();
     }
    },finishRefreshEvent: (){
      if(mounted){
        finishRefresh();
      }
    },finishLoadMoreEvent: (){
      if(mounted){
        finishLoadMore();
      }
    },finishEvent: (data){
     if(mounted){
       Navigator.of(context).pop(data);
     }
    },showContent: (){
     if(mounted){
       showContent();
     }
    },sendMessageEvent: (event){
      if(mounted){
        eventBus.fire(event);
      }
    });
  }

  M createViewModel();


  void onViewModelCreated(){
    viewModel.onCreated();
  }

  ///创建根布局
  Widget buildRootView(BuildContext context,Widget loadingContentWidget);

  Widget createLoadingView(){
    if(viewModel.loadingState == LoadingState.showLoading){
      return _loadingViewPlugin.getLoadingWidget();
    }else if(viewModel.loadingState == LoadingState.showEmpty){
      return _loadingViewPlugin.getEmptyWidget(() => onRetryClick());
    }else if(viewModel.loadingState == LoadingState.showError){
      return _loadingViewPlugin.getErrorWidget(pageError, () => onRetryClick());
    }else {
      return buildLoadingContentView();
    }
  }

  ///创建内容布局
  Widget buildLoadingContentView();

  ///点击重试事件
  void onRetryClick();

  ///结算加载更多
  @override
  void finishLoadMore() {

  }

  ///结束刷新
  @override
  void finishRefresh() {

  }

  ///关闭加载弹窗
  @override
  void hideDialog() {
    if(mounted&&_isShowDialog){
      _isShowDialog = false;
      Navigator.of(context).pop();
    }
  }

  ///显示空白布局
  @override
  void showEmpty() {
    if(mounted){
      setState(() {
        viewModel.loadingState = LoadingState.showEmpty;
      });
    }
  }

  ///显示错误布局
  @override
  void showErrorPage(String error) {
    if(mounted){
      setState(() {
        pageError = error;
        viewModel.loadingState = LoadingState.showError;
      });
    }
  }

  ///显示加载页面
  @override
  void showLoading() {
    if(mounted){
      setState(() {
        viewModel.loadingState = LoadingState.showLoading;
      });
    }
  }

  @override
  void showContent(){
    if(mounted){
      setState(() {
        viewModel.loadingState = LoadingState.showContent;
      });
    }
  }

  @override
  void showLoadingDialog(String msg) {
    if(mounted&&!_isShowDialog){
      _isShowDialog = true;
      try{
        showTransparentDialog(
            context: context,
            barrierDismissible: true,
            builder:(context) {
              return WillPopScope(
                onWillPop: () async {
                  // 拦截到返回键，证明dialog被手动关闭
                  onCloseDialog();
                  return Future.value(true);
                },
                child: ProgressDialog(hintText: msg),
              );
            }
        );
      }catch(e){
        /// 异常原因主要是页面没有build完成就调用Progress。
        print(e);
      }
    }
  }

  @override
  void showToast(String msg) {
    ToastUtils.shotToast(msg,context: context,alignment: Alignment.center);
  }

  void onCloseDialog(){
    _isShowDialog = false;
    viewModel.onDialogDismiss();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onDestroy() {
    ///销毁viewmodel
    viewModel.onDispose();
    _subscription.cancel();
    super.onDestroy();

  }

  @override
  void onResume() {
    viewModel.onResume();
    super.onResume();

  }

  @override
  void onPause() {
    viewModel.onPause();
    super.onPause();
  }

  void finish({dynamic result}){
    Navigator.pop(context,result);
  }
}
class CommonViewModel extends BaseViewModel{
  CommonViewModel(BuildContext context) : super(context);

}