import 'dart:async';
import 'dart:ui';

import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/base_mvvm/base_view_model_mvvm.dart';
import 'package:base_flutter/src/base_mvvm/base_view_mvvm.dart';
import 'package:base_flutter/src/message/message_event.dart';
import 'package:base_flutter/src/utils/app_life_utils.dart';
import 'package:base_flutter/src/widget/loading_view_plugin.dart';
import 'package:base_flutter/src/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';
import 'package:provider/provider.dart';

enum LoadingState { showContent, showError, showEmpty, showLoading }

@immutable
abstract class BaseStatefulMvvmWidget extends StatefulWidget {
  final Map<String, dynamic>? params;

  BaseStatefulMvvmWidget({Key? key, this.params}) : super(key: key) {
    _className = this.runtimeType.toString();
  }

  var _className = "";

  String get className => _className;
}


abstract class BaseMvvmState<M extends BaseViewModel,
        W extends BaseStatefulMvvmWidget> extends State<W>
    with LifecycleMixin
    implements IBaseMvvmView {
  M? vm;

  M get viewModel => vm!;

  LoadingViewPlugin? _loadingViewPlugin;

  bool _isShowDialog = false;

  String pageError = "";
  String emptyMsg = "";

  StreamSubscription? _subscription;

  LoadingState get currentState => vm?.loadingState ?? LoadingState.showContent;

  BuildContext? buildContext;

  String get widgetName => widget.className;

  String get widgetTitle => "";

  bool get isAddToAppLife => true;

  @override
  void initState() {
    super.initState();
    if (BuildConfig.isDebug) {
      Log.d('currentPage', widget.className);
    }
    if(isAddToAppLife){
      AppLifeUtils.instance.openPage(widgetName, widgetTitle, widget);
    }
  }

  @override
  void onContextReady() {
    onCreate();
    super.onContextReady();
  }

  void onCreate() {
    BuildConfig.pageList.add(widget);
    _loadingViewPlugin = LoadingViewPlugin(context);
    _subscription = eventBus.on<SendMessageEvent>().listen((event) {
      receiveMessage(event);
    });
  }

  void addLoadingWidget(
      {LoadingViewBuilder? loadingWidget,
      LoadingViewBuilder? errorWidget,
      LoadingViewBuilder? emptyWidget}) {
    _loadingViewPlugin?.initWidget(
        loadingWidget: loadingWidget!,
        errorWidget: errorWidget!,
        emptyWidget: emptyWidget!);
  }

  void receiveMessage(SendMessageEvent event) {
    if (mounted && vm != null) {
      vm?.receiveMessage(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return initProvider();
  }

  Widget initProvider() {
    return ChangeNotifierProvider<M>(
      create: (_) {
        vm = createViewModel();
        Future.delayed(Duration(milliseconds: 1), () {
          onViewModelCreated();
        });
        return vm!;
      },
      child: Consumer<M>(
        builder: (_, provider, __) {
          vm = provider;
          _addBaseCallback();

          return buildRootView(context, createLoadingView() ?? Container());
        },
      ),
    );
  }

  void _addBaseCallback() {
    vm?.addBaseEvent(toastEvent: (msg) {
      if (mounted) {
        showToast(msg);
      }
    }, showDialogEvent: (msg) {
      if (mounted) {
        showLoadingDialog(msg);
      }
    }, hideDialogEvent: () {
      if (mounted) {
        hideDialog();
      }
    }, showLoadingEvent: () {
      if (mounted) {
        showLoading();
      }
    }, showErrorEvent: (msg) {
      if (mounted) {
        showErrorPage(msg);
      }
    }, showEmptyEvent: (msg) {
      if (mounted) {
        showEmpty(msg: msg);
      }
    }, finishRefreshEvent: () {
      if (mounted) {
        finishRefresh();
      }
    }, finishLoadMoreEvent: () {
      if (mounted) {
        finishLoadMore();
      }
    }, finishEvent: (data) {
      if (mounted) {
        Navigator.of(context).pop(data);
      }
    }, showContent: () {
      if (mounted) {
        showContent();
      }
    }, sendMessageEvent: (event) {
      if (mounted) {
        eventBus.fire(event);
      }
    });
  }

  M createViewModel();

  void onViewModelCreated() {
    vm?.onCreated();
  }

  ///创建根布局
  Widget buildRootView(BuildContext context, Widget loadingContentWidget);

  Widget? createLoadingView() {
    if (vm?.loadingState == LoadingState.showLoading) {
      return _loadingViewPlugin?.getLoadingWidget();
    } else if (vm?.loadingState == LoadingState.showEmpty) {
      return _loadingViewPlugin?.getEmptyWidget(() => onRetryClick());
    } else if (vm?.loadingState == LoadingState.showError) {
      return _loadingViewPlugin?.getErrorWidget(
          pageError, () => onRetryClick());
    } else {
      return buildLoadingContentView();
    }
  }

  ///创建内容布局
  Widget? buildLoadingContentView();

  ///点击重试事件
  void onRetryClick();

  ///结算加载更多
  @override
  void finishLoadMore() {}

  ///结束刷新
  @override
  void finishRefresh() {}

  ///关闭加载弹窗
  @override
  void hideDialog() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      Navigator.of(context).pop();
    }
  }

  ///显示空白布局
  @override
  void showEmpty({String msg = ""}) {
    if (mounted) {
      setState(() {
        emptyMsg = msg;
        vm?.loadingState = LoadingState.showEmpty;
      });
    }
  }

  ///显示错误布局
  @override
  void showErrorPage(String error) {
    if (mounted) {
      setState(() {
        pageError = error;
        vm?.loadingState = LoadingState.showError;
      });
    }
  }

  ///显示加载页面
  @override
  void showLoading() {
    if (mounted) {
      setState(() {
        vm?.loadingState = LoadingState.showLoading;
      });
    }
  }

  @override
  void showContent() {
    if (mounted) {
      setState(() {
        vm?.loadingState = LoadingState.showContent;
      });
    }
  }

  bool get touchOutDismiss => true;

  bool get backDismiss => true;

  @override
  void showLoadingDialog(String msg) {

    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      print("12312331");
      try {
        showTransparentDialog(
            context: context,
            barrierDismissible: touchOutDismiss,
            builder: (context) {
              return PopScope(
                onPopInvoked: (didPop) async {
                  // 拦截到返回键，证明dialog被手动关闭
                  print(didPop);
                  onCloseDialog();
                },
                canPop: backDismiss,
                child: ProgressDialog(hintText: msg),
              );
            });
      } catch (e) {
        /// 异常原因主要是页面没有build完成就调用Progress。
        print(e);
      }
    }
  }

  @override
  void showToast(String msg) {
    ToastUtils.shotToast(msg, context: context, alignment: Alignment.center);
  }

  void onCloseDialog() {
    _isShowDialog = false;
    vm?.onDialogDismiss();
  }

  @override
  void dispose() {
    _clearLoading();
    onDestroy();
    _loadingViewPlugin = null;
    if(isAddToAppLife){
      AppLifeUtils.instance.closePage(widgetName, widgetTitle, widget);
    }
    super.dispose();
    vm = null;
  }

  void _clearLoading() {
    _loadingViewPlugin?.release();
  }

  void onDestroy() {
    ///销毁viewmodel
    vm?.onDispose();
    BuildConfig.pageList.remove(widget);
    _subscription?.cancel();
    _subscription = null;
    buildContext = null;
  }

  @override
  void onResume() {
    vm?.onResume();
  }

  @override
  void onPause() {
    vm?.onPause();
  }

  void finish({dynamic result}) {
    Navigator.pop(context, result);
  }

}

abstract class BaseMvvmListState<M extends BaseListViewModel,
    W extends BaseStatefulMvvmWidget> extends BaseMvvmState<M, W> {
  @override
  Widget? buildLoadingContentView() {
    return SmartRefresher(
      controller: viewModel.controller!,
      onRefresh: (){
        viewModel.requestRefresh(showAni: false);
      },
      onLoading: viewModel.requestLoadMore,
      enablePullDown: canPullDown,
      enablePullUp: canPullUp,
      child: ListView.separated(
          padding: listPadding,
          itemBuilder: (context, index) {
            return createItemWidget(index);
          },
          separatorBuilder: (context, index) {
            return separatorDivider;
          },
          itemCount: viewModel.listItems.length),
    );
  }

  bool get canPullUp => false;

  bool get canPullDown => true;

  Widget get separatorDivider => Container();

  Widget createItemWidget(int index);

  EdgeInsets get listPadding => EdgeInsets.zero;

  @override
  void onRetryClick() {
    viewModel.requestRefresh();
  }
}

abstract class BaseMvvmRefreshState<M extends BaseListViewModel,
    W extends BaseStatefulMvvmWidget> extends BaseMvvmState<M, W> {
  @override
  Widget? buildLoadingContentView() {
    return SmartRefresher(
        controller: viewModel.controller!,
        onRefresh: viewModel.requestRefresh,
        onLoading: viewModel.requestLoadMore,
        enablePullDown: canPullDown,
        enablePullUp: canPullUp,
        child: createScrollWidget());
  }

  bool get canPullUp => false;

  bool get canPullDown => true;

  Widget createScrollWidget();

  @override
  void onRetryClick() {
    viewModel.requestRefresh();
  }
}

class CommonViewModel extends BaseViewModel {
  CommonViewModel(BuildContext context) : super(context);
}
