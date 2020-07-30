import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/base_mvvm/base_view_model_mvvm.dart';
import 'package:base_flutter/src/base_mvvm/base_view_mvvm.dart';
import 'package:base_flutter/src/widget/loading_view_plugin.dart';
import 'package:base_flutter/src/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


enum LoadingState{
  showContent,
  showError,
  showEmpty,
  showLoading
}

abstract class BaseStatefulMvvmWidget extends StatefulWidget {}

abstract class BaseMvvmState<M extends BaseViewModel>
    extends State<BaseStatefulMvvmWidget> implements IBaseMvvmView {
  M viewModel;

  LoadingViewPlugin _loadingViewPlugin;

  bool _isShowDialog = false;

  LoadingState _loadingState = LoadingState.showContent;

  String pageError = "";

  @override
  void initState() {
    _loadingViewPlugin = LoadingViewPlugin(context);
    super.initState();

  }

  void addLoadingWidget({Widget loadingWidget, Widget errorWidget, Widget emptyWidget}){
    _loadingViewPlugin.initWidget(loadingWidget: loadingWidget,errorWidget: errorWidget,emptyWidget: emptyWidget);
  }


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<M>(
      create: (_) => createViewModel(),
      child:Consumer<M>(builder: (_, provider, __) {
        viewModel = provider;
        viewModel.addBaseEvent(toastEvent: (msg) {
          showToast(msg);
        },showDialogEvent: (msg){
          showLoadingDialog(msg);
        },hideDialogEvent: (){
          hideDialog();
        },showLoadingEvent: (){
          showLoading();
        },showErrorEvent: (msg){
          showErrorPage(msg);
        },showEmptyEvent: (){
          showEmpty();
        },finishRefreshEvent: (){
          finishRefresh();
        },finishLoadMoreEvent: (){
          finishLoadMore();
        },finishEvent: (data){
          Navigator.of(context).pop(data);
        },showContent: (){
          showContent();
        });
        return buildRootView(createLoadingView());
      },),
    );
  }

  M createViewModel();

  ///创建根布局
  Widget buildRootView(Widget loadingContentWidget);

  Widget createLoadingView(){
    if(_loadingState == LoadingState.showLoading){
      return _loadingViewPlugin.getLoadingWidget();
    }else if(_loadingState == LoadingState.showEmpty){
      return _loadingViewPlugin.getEmptyWidget(() => onRetryClick());
    }else if(_loadingState == LoadingState.showError){
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
        _loadingState = LoadingState.showEmpty;
      });
    }
  }

  ///显示错误布局
  @override
  void showErrorPage(String error) {
    if(mounted){
      setState(() {
        pageError = error;
        _loadingState = LoadingState.showError;
      });
    }
  }

  ///显示加载页面
  @override
  void showLoading() {
    if(mounted){
      setState(() {
        _loadingState = LoadingState.showLoading;
      });
    }
  }

  @override
  void showContent(){
    if(mounted){
      setState(() {
        _loadingState = LoadingState.showContent;
      });
    }
  }

  @override
  void showLoadingDialog(String msg) {
    if(mounted&&!_isShowDialog){
      try{
        showTransparentDialog(
            context: context,
            barrierDismissible: false,
            builder:(context) {
              _isShowDialog = true;
              return WillPopScope(
                onWillPop: () async {
                  // 拦截到返回键，证明dialog被手动关闭
                  onCloseDialog();
                  return Future.value(true);
                },
                child:  ProgressDialog(hintText: msg),
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
    ToastUtils.shotToast(msg);
  }

  void onCloseDialog(){
    viewModel.onDialogDismiss();
  }

  @override
  void dispose() {
    super.dispose();
    ///销毁viewmodel
    viewModel.onDispose();
  }
}
