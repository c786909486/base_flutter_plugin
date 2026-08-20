import 'dart:async';
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterlifecyclehooks/flutterlifecyclehooks.dart';

enum LoadingState { showContent, showError, showEmpty, showLoading }

abstract class BaseStatefulMvvmWidget extends StatefulWidget {
  final Map<String, dynamic>? params;

  BaseStatefulMvvmWidget({Key? key, this.params}) : super(key: key);
}

abstract class BaseMvvmState<M extends BaseViewModel,
        W extends BaseStatefulMvvmWidget> extends State<W> with LifecycleMixin,PageLifeCircleMixin,RouteAware
    implements IBaseMvvmView {
  M? vm;

  M get viewModel => vm!;

  LoadingViewPlugin? _loadingViewPlugin;

  bool _isShowDialog = false;

  /// 当前页面是否正在展示（处于页面栈最上层、未被其他页面覆盖）。
  /// 页面进入/返回时置为 true，跳转到其他页面/关闭时置为 false。
  bool _isPageVisible = false;

  /// 获取当前页面是否正在展示。
  /// - 页面首次进入、从其他页面回退回来时为 true；
  /// - 跳转到其他页面、页面被关闭时为 false。
  bool get isPageVisible => _isPageVisible;

  String pageError = "";
  String emptyMsg = "";

  StreamSubscription? _subscription;

  LoadingState get currentState => vm?.loadingState ?? LoadingState.showContent;

  BuildContext? buildContext;

  String get widgetName => _className;

  String get widgetTitle => "";

  bool get isAddToAppLife => true;

  bool _didRunOnContextReady = false;

  String _className = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      onContextInit(context);
      _className = widget.runtimeType.toString();
      if (BuildConfig.isDebug) {
        Log.d('currentPage', _className);
      }
      if (isAddToAppLife) {
        AppLifeUtils.instance.openPage(widgetName, widgetTitle, widget);
      }
      if(vm!=null){
        onViewModelCreated();
      }
      // 页面首次进入展示，标记为可见并回调 onResume
      onResume();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRunOnContextReady) {
      _didRunOnContextReady = true;

    }
  }

  void onContextInit(BuildContext context) {
    onCreate();
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
        loadingWidget: loadingWidget,
        errorWidget: errorWidget,
        emptyWidget: emptyWidget);
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
        // 事件回调只在 vm 创建时注册一次，避免每次 rebuild 重复创建闭包
        _addBaseCallback();
        return vm!;
      },
      child: Consumer<M>(
        builder: (_, provider, __) {
          vm = provider;

          return buildRootView(context, createLoadingView(context) ?? Container());
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

  Widget? createLoadingView(BuildContext context) {
    if (vm?.loadingState == LoadingState.showLoading) {
      return _loadingViewPlugin?.getLoadingWidget(context);
    } else if (vm?.loadingState == LoadingState.showEmpty) {
      return _loadingViewPlugin?.getEmptyWidget(context,emptyMsg,() => onRetryClick());
    } else if (vm?.loadingState == LoadingState.showError) {
      return _loadingViewPlugin?.getErrorWidget(context,
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
      emptyMsg = msg;
      vm?.loadingState = LoadingState.showEmpty;
      vm?.notifyStateChange();
    }
  }

  ///显示错误布局
  @override
  void showErrorPage(String error) {
    if (mounted) {
      pageError = error;
      vm?.loadingState = LoadingState.showError;
      vm?.notifyStateChange();
    }
  }

  ///显示加载页面
  @override
  void showLoading() {
    if (mounted) {
      vm?.loadingState = LoadingState.showLoading;
      vm?.notifyStateChange();
    }
  }

  @override
  void showContent() {
    if (mounted) {
      vm?.loadingState = LoadingState.showContent;
      vm?.notifyStateChange();
    }
  }

  bool get touchOutDismiss => false;

  bool get backDismiss => true;

  @override
  void showLoadingDialog(String msg) {

    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      try {
        showTransparentDialog(
            context: context,
            barrierDismissible: touchOutDismiss,
            builder: (context) {
              return PopScope(
                onPopInvoked: (didPop) async {
                  // 拦截到返回键，证明dialog被手动关闭
                  onCloseDialog();
                },
                canPop: backDismiss,
                child: ProgressDialog(hintText: msg),
              );
            });
      } catch (e) {
        /// 异常原因主要是页面没有build完成就调用Progress。
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
    // 页面关闭，若当前仍处于展示状态则先回调 onPause
    if (_isPageVisible) {
      onPause();
    }
    _clearLoading();
    onDestroy();
    _loadingViewPlugin = null;
    if (isAddToAppLife) {
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


  void finish({dynamic result}) {
    Navigator.pop(context, result);
  }

  @override
  void onResume() {
    _isPageVisible = true;
    // if (mounted) {
    //   setState(() {});
    // }
  }

  @override
  void onPause() {
    _isPageVisible = false;
  }
}

abstract class BaseMvvmListState<M extends BaseListViewModel,
    W extends BaseStatefulMvvmWidget> extends BaseMvvmState<M, W> {
  @override
  Widget? buildLoadingContentView() {
    return SmartRefresher(
      controller: viewModel.controller!,
      onRefresh: () {
        viewModel.requestRefresh(showAni: false);
      },
      onLoading: viewModel.requestLoadMore,
      enablePullDown: canPullDown,
      enablePullUp: canPullUp,
      child: itemExtent != null
          // 配置了固定item高度时使用builder，滚动时跳过layout、性能更优；
          // 注意此时separatorDivider不生效，分隔线请在item内部自行处理
          ? ListView.builder(
              padding: listPadding,
              itemExtent: itemExtent,
              itemBuilder: (context, index) {
                return createItemWidget(index);
              },
              itemCount: viewModel.listItems.length)
          : ListView.separated(
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

  ///列表项固定高度，可显著提升滚动性能；
  ///若列表项高度不固定，返回null使用自动布局
  double? get itemExtent => null;

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
