# base_flutter API 速查

> 以仓库 `lib/src/base_mvvm/` 与 `lib/src/utils/` 当前实现为准（base_flutter 0.0.2）。

## 入口 Widget

```dart
abstract class BaseStatefulMvvmWidget extends StatefulWidget {
  final Map<String, dynamic>? params;          // 路由参数，页面内 widget.params?['key'] 读取
  const BaseStatefulMvvmWidget({Key? key, this.params});
}
```

页面类继承它，并可透传 `params`：

```dart
class XxxPage extends BaseStatefulMvvmWidget {
  const XxxPage({super.key, super.params});
  @override
  State<StatefulWidget> createState() => _XxxPageState();
}
```

## State 基类

### BaseMvvmState<M extends BaseViewModel, W extends BaseStatefulMvvmWidget>

必须实现：

| 成员 | 说明 |
| --- | --- |
| `M createViewModel()` | 返回 `XxxViewModel(context)` |
| `Widget buildRootView(BuildContext context, Widget loadingContentWidget)` | 根布局，body 用 `loadingContentWidget` |
| `Widget? buildLoadingContentView()` | 内容态正文；返回 `null` 表示不需要正文 |
| `void onRetryClick()` | 错误态/空态点击重试 |

可直接使用：

| 成员 | 说明 |
| --- | --- |
| `M get viewModel` | 当前 ViewModel（首帧前不可用；不要放 `initState`） |
| `bool get isPageVisible` | 页面是否处于可见状态 |
| `LoadingState get currentState` | `showContent / showLoading / showError / showEmpty` |
| `void onCreate()` | 首帧后回调，做 `addLoadingWidget` 等 UI 初始化 |
| `void onViewModelCreated()` | ViewModel 创建后回调 |
| `void addLoadingWidget({LoadingViewBuilder? loadingWidget, errorWidget, emptyWidget})` | 自定义加载/错误/空占位，`(context, msg) => Widget` |
| `void showLoading()` / `showContent()` | 切换加载/内容态 |
| `void showErrorPage(String error)` / `void showEmpty({String msg = ""})` | 切换错误/空态 |
| `void showToast(String msg)` | 使用全局 Toast |
| `void showLoadingDialog(String msg)` / `void hideDialog()` | 加载弹窗；`touchOutDismiss`、`backDismiss` 控制能否手动关闭 |
| `void finishRefresh()` / `void finishLoadMore()` | 完成刷新/加载更多 |
| `void finish({dynamic result})` | 关闭当前页并返回结果 |
| `bool get touchOutDismiss => false` / `bool get backDismiss => true` | 弹窗手势/返回键策略 |
| `void receiveMessage(SendMessageEvent event)` | 接收事件总线消息 |
| `onResume()` / `onPause()` | 重写时必须 `super`，维护 `isPageVisible` |

### BaseMvvmListState<M extends BaseListViewModel, W>

在 `BaseMvvmState` 基础上内置 `SmartRefresher(controller: viewModel.controller)` +
`ListView`（`itemExtent` 非空用 `ListView.builder`，否则 `ListView.separated`）。

必须实现：`Widget createItemWidget(int index)`。

可重写：

| 成员 | 默认值 | 说明 |
| --- | --- | --- |
| `double? get itemExtent` | `null` | 固定行高，提升滚动性能；设置后 `separatorDivider` 不生效 |
| `bool get canPullUp` | `false` | 上拉加载更多开关 |
| `bool get canPullDown` | `true` | 下拉刷新开关 |
| `Widget get separatorDivider` | `Container()` | 分隔线 |
| `EdgeInsets get listPadding` | `EdgeInsets.zero` | 列表内边距 |

固定行为：`onRefresh → requestRefresh(showAni: false)`，`onLoading → requestLoadMore`，
`onRetryClick → requestRefresh()`。

### BaseMvvmRefreshState<M extends BaseListViewModel, W>

内置 `SmartRefresher`，包裹 `createScrollWidget()` 返回的任意滚动组件。

必须实现：`Widget createScrollWidget()`（滚动组件加 `AlwaysScrollableScrollPhysics`）。

可重写：`canPullUp`（默认 `false`）、`canPullDown`（默认 `true`）。
固定行为：`onRefresh → requestRefresh`，`onLoading → requestLoadMore`，
`onRetryClick → requestRefresh()`。

## ViewModel 基类

### BaseViewModel with ChangeNotifier

```dart
BaseViewModel(BuildContext context);   // 子类：XxxViewModel(super.context);
```

| 成员 | 说明 |
| --- | --- |
| `BuildContext? get context` | 页面上下文 |
| `bool mounted` | 是否存活 |
| `LoadingState? loadingState` | 当前页面状态 |
| `void onCreated()` | ViewModel 创建后回调，做首屏加载 |
| `void onDispose()` | 销毁回调，清理自定义资源 |
| `void onDialogDismiss()` | 加载弹窗被用户关闭时回调 |
| `void receiveMessage(SendMessageEvent event)` | 接收事件总线 |
| `void showToast(String msg)` | toast |
| `void showLoadingDialog({String msg = "加载中..."})` / `hideDialog()` | 加载弹窗 |
| `void showLoadingState()` / `showContent()` | 切换加载/内容态 |
| `void showErrorState(String error)` | 错误态 |
| `void showEmptyState({String msg = "暂无数据"})` | 空态 |
| `void finish({dynamic data})` | 关闭页面 |
| `void sendMessage(SendMessageEvent event)` | 发送事件总线消息 |
| `void notifyStateChange()` | 等价 `notifyListeners()` |
| `void addModel(BaseMvvmModel model)` / `addModels(...)` | 绑定 Model，页面销毁时自动 `onCleared()` |

### BaseListViewModel<T> extends BaseViewModel

| 成员 | 说明 |
| --- | --- |
| `List<T> listItems` | 列表数据 |
| `RefreshController? controller` | SmartRefresher 控制器（基类自动创建/置空） |
| `int page = 1` | 当前页码，刷新重置为 1 |
| `int pageLength = 20` | 每页条数 |
| `Future<List<T>> requestListData()` | **抽象**：返回当前页数据 |
| `Future<void> requestRefresh({bool showAni = true})` | 刷新：请求第一页并替换 `listItems` |
| `Future<void> requestLoadMore()` | 加载更多：追加 `listItems` |
| `setSearchDateRange(start, end)` / `selectStartDate(...)` / `selectEndDate(...)` | 日期区间筛选辅助 |
| `String startDateStr / endDateStr`、`DateTime? startDateTime / endDateTime` | 日期筛选状态 |

`requestRefresh` 约定：`listItems` 为空或处于空/错误态时自动 `showLoadingState()`；
成功且返回非空 → `showContent()`；返回空 → `showEmptyState()`；异常 → `showErrorState(e.toNetError())`。
`requestLoadMore` 返回空时 `showToast("暂无更多数据")`。

## 枚举

```dart
enum LoadingState { showContent, showError, showEmpty, showLoading }
```

## 事件总线

```dart
eventBus.fire(SendMessageEvent(1, obj: data));        // 页面/VM 内可用 viewModel.sendMessage(...)
class SendMessageEvent { final int msgCode; final dynamic obj; }
// 页面 VM 重写 receiveMessage(event) 接收；State 层已自动转发。
```

## 路由

```dart
Go().push(Widget page, {params, settings, maintainState = true, fullscreenDialog = false});
Go().pushAndPop(Widget page, {...});            // pushReplacement
Go().pushRemoveUntil(Widget page, {...});
Go().pushName(String name, {params});
Go().pop({result});
finish({result});                               // State 内关闭当前页
```

全局 `NavigateService.getInstance().navigator` 提供 `push/pushNamed/pushReplacement/pop`。
命名路由需要 `class AppGo extends Go` 重写 `Widget? createRoute(String name, {params})`。

## 常用 UI / 工具

```dart
CommonAppBar(String title, {List<Widget>? actions, Widget? leading, double elevation = 0.5,
    bool centerTitle = true, Color backgroundColor = Colors.white, PreferredSizeWidget? bottom});
CommonText(String? text, {Color textColor = Colors.black, double textSize = 16, String hintText = "",
    Color hintColor = Colors.grey, TextAlign textAlign = TextAlign.start, double? height,
    FontWeight fontWeight = FontWeight.normal, bool canCopy = false});

// Widget 扩展
widget.addToContainer({alignment, padding, color, decoration, width, height, margin, ...});
widget.onTap(onTap, {onDoubleTap, onLongPress, delayTime = 250, ...});
widget.setWeight(int);                 // Expanded
widget.toRound({borderRadius, ...});   // ClipRRect
widget.setLocation({left, right, top, bottom}); // Positioned

// 其他扩展
8.borderRadius;                        // BorderRadius.circular(8)
'2024-01-01'.toDate(); '1'.toInt(); '1.0'.toDouble();
's'.isNullOrEmpty(); e.toNetError();   // 网络异常转文案
[Widget].insertWidget(SizedBox(height: 8)); // 列表插入分隔
```

## 网络

```dart
final map = await HttpGo.instance.getData(url, {data, options, cancelToken});
final map = await HttpGo.instance.postData(url, {data, queryParameters, options, cancelToken});
final str = await HttpGo.instance.getDataString(url, {data});
// 表单提交
await HttpGo.instance.postData(url, data: data,
    options: Options(headers: headers, contentType: Headers.formUrlEncodedContentType));
```

`base_flutter.dart` 已 export `dio`、`pull_to_refresh`、`provider`、`sp_util`、
`shared_preferences`、`cached_network_image`、`photo_view`、`dio_net_work` 等，
业务侧通常无需在 pubspec 里重复声明。

## 初始化

```dart
NavigatorKey: NavigateService.getInstance().key
Observer:     StateNavigatorObserver()
网络(web):    NetPlatform.init([withCredentials])
存储:         await SpUtil.getInstance()
开发工具:     DevConfig.instance.init()
```
