# Base Flutter 框架调用文档

## 概述

Base Flutter 是一个基于 MVVM 架构模式的 Flutter 开发框架，使用 Provider 进行状态管理。框架提供了完整的页面生命周期管理、网络请求、UI 状态控制、分页列表等开箱即用的功能，旨在提高 Flutter 应用开发效率。

### 核心特性

- **MVVM 架构**：清晰的关注点分离（Widget/ViewModel/Model）
- **状态管理**：基于 Provider + ChangeNotifier
- **页面状态控制**：自动管理 Loading/Error/Empty/Content 状态
- **分页列表**：内置下拉刷新、上拉加载更多
- **生命周期管理**：支持 onResume/onPause 页面生命周期回调
- **消息总线**：基于 EventBus 的跨页面通信
- **通用 UI 组件**：丰富的可复用组件库
- **工具类**：网络请求、路由导航、Toast、日志等实用工具

## 核心架构

### 架构分层

```
┌─────────────────────────────────────────────────────────────┐
│                    Widget (BaseStatefulMvvmWidget)          │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              State (BaseMvvmState)                     │  │
│  │  ┌──────────────┐    ChangeNotifierProvider           │  │
│  │  │  build()     │──────────────────────┐              │  │
│  │  │  initProvider│    Consumer<M>       │              │  │
│  │  └──────────────┘    ┌─────────────┐   │              │  │
│  │                      │ ViewModel   │◄──┘              │  │
│  │  IBaseMvvmView ◄─────│ (M)         │                  │  │
│  │  showLoading()        │             │                  │  │
│  │  showError()          │  Listeners  │                  │  │
│  │  showEmpty()          │  callbacks  │                  │  │
│  │  showContent()        └──────┬──────┘                  │  │
│  │  showToast()                 │                         │  │
│  │  finishRefresh()            │                         │  │
│  └─────────────────────────────┼─────────────────────────┘  │
│                                │                            │
│  ┌─────────────────────────────▼─────────────────────────┐  │
│  │              Model (BaseMvvmModel)                     │  │
│  │  - 数据层/业务逻辑                                      │  │
│  │  - onCleared() 生命周期                                │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 状态机：LoadingState

```dart
enum LoadingState { showContent, showError, showEmpty, showLoading }
```

| 状态 | 显示内容 | 说明 |
|------|----------|------|
| `showContent` | 正常内容 | 由 `buildLoadingContentView()` 返回 |
| `showLoading` | 加载中视图 | 全局或页面级自定义 |
| `showError` | 错误视图 | 点击重试 |
| `showEmpty` | 空数据视图 | 点击重试 |

## 核心类使用指南

### 1. BaseStatefulMvvmWidget

页面 Widget 基类，所有页面必须继承此类。

```dart
class MyPage extends BaseStatefulMvvmWidget {
  @override
  State<StatefulWidget> createState() => _MyPageState();
}
```

**参数传递**：
```dart
// 通过构造函数传递参数
class MyPage extends BaseStatefulMvvmWidget {
  final String id;
  MyPage({required this.id});
  
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

// 导航时传递
Go().push(MyPage(id: '123'));
```

### 2. BaseMvvmState

页面 State 基类，核心职责：

| 方法 | 说明 | 必须实现 |
|------|------|----------|
| `createViewModel()` | 创建 ViewModel 实例 | ✅ |
| `buildRootView(context, loadingContentWidget)` | 构建根布局 | ✅ |
| `buildLoadingContentView()` | 构建内容视图 | ✅ |
| `onRetryClick()` | 重试点击回调 | ✅ |
| `receiveMessage(event)` | 接收消息总线消息 | ❌ |

**完整示例**：
```dart
class _MyPageState extends BaseMvvmState<MyViewModel, MyPage> {
  @override
  MyViewModel createViewModel() => MyViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('我的页面'),
      body: loadingContentWidget, // 自动处理 loading/error/empty/content
    );
  }

  @override
  Widget? buildLoadingContentView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.title),
          Text(viewModel.description),
        ],
      ),
    );
  }

  @override
  void onRetryClick() {
    viewModel.requestData(); // 点击重试时重新请求数据
  }

  @override
  void receiveMessage(SendMessageEvent event) {
    if (event.msgCode == 1001) {
      // 处理消息
    }
  }
}
```

### 3. BaseViewModel

ViewModel 基类，继承自 `ChangeNotifier`。

**生命周期**：
```
构造函数 → init() → [View创建完成] → onCreated() → [业务逻辑] → onDispose() → _release()
```

**核心方法**：

| 方法 | 说明 | 使用场景 |
|------|------|----------|
| `init()` | 构造时初始化 | 初始化变量、配置 |
| `onCreated()` | View 创建完成后调用 | 发起网络请求、订阅事件 |
| `onDispose()` | 销毁时调用 | 取消订阅、释放资源 |
| `addModel(model)` | 添加关联的 Model | 管理数据模型 |
| `addModels(models)` | 批量添加 Model | 管理多个数据模型 |
| `showContent()` | 显示内容视图 | 数据加载完成 |
| `showErrorState(error)` | 显示错误视图 | 请求失败 |
| `showEmptyState()` | 显示空视图 | 数据为空 |
| `showLoadingDialog(msg)` | 显示加载弹窗 | 需要阻塞用户操作时 |
| `hideDialog()` | 隐藏加载弹窗 | 加载完成 |
| `showToast(msg)` | 显示 Toast | 提示信息 |
| `finishRefresh()` | 结束下拉刷新 | 刷新完成 |
| `finishLoadMore()` | 结束上拉加载 | 加载更多完成 |
| `sendMessage(event)` | 发送消息 | 跨页面通信 |
| `finish(data: result)` | 关闭页面并返回结果 | 页面间数据传递 |

**ViewModel 示例**：
```dart
class MyViewModel extends BaseViewModel {
  MyViewModel(BuildContext context) : super(context);

  String title = "";
  String description = "";
  List<String> items = [];

  @override
  void init() {
    // 构造时初始化，不要在这里发起网络请求
    title = "初始标题";
  }

  @override
  void onCreated() {
    // View 创建完成后，可以发起网络请求
    requestData();
  }

  Future<void> requestData() async {
    showLoadingDialog(); // 显示加载弹窗
    try {
      var data = await HttpGo.instance.getData("https://api.example.com/data");
      title = data['title'];
      description = data['description'];
      items = List<String>.from(data['items']);
      hideDialog(); // 隐藏加载弹窗
      showContent(); // 显示内容视图，触发 UI 刷新
    } catch (e) {
      hideDialog();
      showErrorState(e.toNetError()); // 显示错误视图
    }
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners(); // 通知 UI 更新
  }

  @override
  void onDispose() {
    // 清理资源
    super.onDispose();
  }
}
```

### 4. BaseListViewModel

分页列表 ViewModel 基类，自动管理分页逻辑。

**核心属性**：

| 属性 | 说明 | 默认值 |
|------|------|--------|
| `page` | 当前页码 | 1 |
| `pageLength` | 每页条数 | 20 |
| `listItems` | 列表数据 | 空列表 |
| `refreshController` | 刷新控制器 | 内置 |

**必须实现的方法**：

```dart
class ListViewModel extends BaseListViewModel<String> {
  ListViewModel(BuildContext context) : super(context);

  @override
  Future<List<String>> requestListData() async {
    // 实际项目中替换为网络请求
    var data = await HttpGo.instance.getData(
      "https://api.example.com/list",
      params: {'page': page, 'pageSize': pageLength},
    );
    
    // 返回数据列表
    return (data['list'] as List).map((e) => e.toString()).toList();
  }

  @override
  void onCreated() {
    super.onCreated();
    requestRefresh(showAni: false); // 首次加载，不显示动画
  }
}
```

**列表页面示例**：
```dart
class ListPage extends BaseStatefulMvvmWidget {
  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends BaseMvvmListState<ListViewModel, ListPage> {
  @override
  ListViewModel createViewModel() => ListViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('列表页'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createItemWidget(int index) {
    var item = viewModel.listItems[index];
    return ListTile(
      title: CommonText(item),
      onTap: () {
        // 点击事件
      },
    );
  }

  @override
  bool get canPullUp => true; // 启用上拉加载
}
```

### 5. BaseModel

数据模型基类，定义生命周期回调。

```dart
class UserModel extends BaseMvvmModel {
  String name = '';
  String avatar = '';

  @override
  void onCleared() {
    // 清理资源
  }
}
```

## 页面状态管理

### 自动状态切换

框架自动根据 `loadingState` 显示对应视图：

```dart
// 在 ViewModel 中控制状态
viewModel.showContent();      // 显示内容
viewModel.showErrorState(e);  // 显示错误
viewModel.showEmptyState();   // 显示空视图
```

### 自定义加载视图

```dart
// 全局设置（在 main.dart 中）
LoadingViewPlugin.initGlobeLoading(
  loadingWidget: Center(child: CircularProgressIndicator()),
  errorWidget: (error, retry) => Column(
    children: [
      Text('加载失败: $error'),
      ElevatedButton(onPressed: retry, child: Text('重试')),
    ],
  ),
  emptyWidget: (retry) => Column(
    children: [
      Text('暂无数据'),
      ElevatedButton(onPressed: retry, child: Text('刷新')),
    ],
  ),
);

// 页面级设置
class _MyPageState extends BaseMvvmState<MyViewModel, MyPage> {
  @override
  void initState() {
    super.initState();
    addLoadingWidget(
      loadingWidget: Center(child: MyCustomLoading()),
      errorWidget: (error, retry) => MyCustomError(error: error, onRetry: retry),
      emptyWidget: (retry) => MyCustomEmpty(onRetry: retry),
    );
  }
}
```

### 加载弹窗

```dart
// 显示加载弹窗（阻塞用户操作）
showLoadingDialog('加载中...');

// 隐藏加载弹窗
hideDialog();
```

## 网络请求

### 基本使用

```dart
// GET 请求
var data = await HttpGo.instance.getData("https://api.example.com/data");

// GET 请求带参数
var data = await HttpGo.instance.getData(
  "https://api.example.com/data",
  params: {'page': 1, 'pageSize': 20},
);

// POST 请求
var data = await HttpGo.instance.postData(
  "https://api.example.com/data",
  data: {'key': 'value'},
);

// 上传文件
var data = await HttpGo.instance.uploadFile(
  "https://api.example.com/upload",
  filePath: '/path/to/file',
  fileName: 'file.jpg',
);

// 下载文件
await HttpGo.instance.downloadFile(
  "https://api.example.com/file",
  '/path/to/save/file',
  onProgress: (progress) {
    print('下载进度: $progress%');
  },
  onError: (error) {
    print('下载失败: $error');
  },
);
```

### 在 ViewModel 中使用网络请求

```dart
class MyViewModel extends BaseViewModel {
  MyViewModel(BuildContext context) : super(context);

  Future<void> requestData() async {
    showLoadingDialog(); // 显示加载弹窗
    try {
      var data = await HttpGo.instance.getData("https://api.example.com/data");
      // 处理数据
      hideDialog();
      showContent();
    } catch (e) {
      hideDialog();
      showErrorState(e.toNetError()); // 显示错误视图
    }
  }
}
```

### 网络错误处理

```dart
// 自定义错误格式
NetErrorUtils.initErrorFormat(
  onError: (error) {
    // 自定义错误处理
    return '请求失败: ${error.message}';
  },
);
```

## 路由导航

### 使用 Go 类导航

```dart
// Push 一个新页面
Go().push(MyPage());

// Push 并设置路由名
Go().open(MyPage(), name: '/my-page');

// Push 并替换当前页
Go().pushAndPop(MyPage());

// Push 并清除路由栈（跳转到首页）
Go().pushRemoveUntil(MyPage());

// Push 带参数
Go().push(MyPage(id: '123'));

// 按路由名 Push
Go().pushName('/my-page');

// 返回上一页
Go().pop();

// 返回上一页并传递数据
Go().pop(result: '返回的数据');
```

### 在 ViewModel 中关闭页面

```dart
class MyViewModel extends BaseViewModel {
  MyViewModel(BuildContext context) : super(context);

  void submitData() {
    // 处理业务逻辑...
    
    // 关闭页面并返回结果
    finish(data: '提交成功');
  }
}
```

### 无 Context 导航

```dart
// 使用 NavigateService 单例
NavigateService.getInstance().push(MyPage());
NavigateService.getInstance().pop();
```

## 消息总线

### 发送消息

```dart
// 在 ViewModel 中发送
sendMessage(SendMessageEvent(1001, obj: {'key': 'value'}));

// 直接发送
SendMessageEvent(1001, obj: data).postMessage();
```

### 接收消息

```dart
class _MyPageState extends BaseMvvmState<MyViewModel, MyPage> {
  @override
  void receiveMessage(SendMessageEvent event) {
    if (event.msgCode == 1001) {
      // 处理消息
      var data = event.obj;
      // 更新 UI
    }
  }
}
```

### 消息码定义

```dart
class MessageCode {
  static const int kLoginSuccess = 1001;
  static const int kLogout = 1002;
  static const int kDataUpdate = 1003;
}
```

## 页面生命周期

### 生命周期回调

```dart
class _MyPageState extends BaseMvvmState<MyViewModel, MyPage> {
  @override
  void onResume() {
    // 页面从后台回到前台
    // 可以刷新数据
  }

  @override
  void onPause() {
    // 页面进入后台
    // 可以暂停动画、停止计时器等
  }
}
```

### 页面生命周期追踪

```dart
// 监听页面打开
AppLifeUtils.instance.addListener((event) {
  if (event is PageOpenEvent) {
    print('页面打开: ${event.pageName}');
  } else if (event is PageCloseEvent) {
    print('页面关闭: ${event.pageName}');
  }
});
```

## 通用 UI 组件

### 常用组件

| 组件 | 说明 | 使用示例 |
|------|------|----------|
| `CommonText` | 通用文本 | `CommonText('文本')` |
| `CommonAppBar` | 通用 AppBar | `CommonAppBar('标题')` |
| `ImageLoad` | 图片加载 | `ImageLoad('https://example.com/image.jpg')` |
| `ITextField` | 带清除按钮的输入框 | `ITextField(hintText: '请输入')` |
| `ProgressDialog` | 加载弹窗 | `ProgressDialog.show(context)` |
| `ExpandableText` | 可展开文本 | `ExpandableText('长文本...')` |
| `IconTitleWidget` | 图标+标题列表项 | `IconTitleWidget(icon: Icons.home, title: '首页')` |
| `CircleProcessWidget` | 圆形进度条 | `CircleProcessWidget(progress: 0.7)` |

### 扩展方法

```dart
// 日期格式化
DateTime.now().toDateStr(formats: 'yyyy-MM-dd');

// JSON 字符串转 Map
String jsonStr = '{"key": "value"}';
Map<String, dynamic> map = jsonStr.toObjMap();

// 安全类型转换
String numStr = "123";
int num = numStr.toInt();
double doubleNum = numStr.toDouble();

// 空值判断
String? str;
if (str.isNullOrEmpty()) { ... }
if (str.trimIsNullOrEmpty()) { ... }

// Widget 扩展
Widget()
  .addToContainer(padding: EdgeInsets.all(10)) // 包裹 Container
  .setWeight(1) // 包裹 Expanded
  .onTap(() { print('点击'); }) // 添加点击事件（防抖 250ms）
  .toRound(8.0) // 圆角裁剪
  .toCircle(); // 圆形裁剪
```

## 工具类

### Toast

```dart
ToastUtils.show('提示信息');
ToastUtils.showSuccess('成功');
ToastUtils.showError('失败');
```

### 日志

```dart
Log.d('调试信息');
Log.i('普通信息');
Log.w('警告信息');
Log.e('错误信息');
```

### 本地存储

```dart
// 保存数据
await SpUtil.getInstance();
SpUtil.putString('key', 'value');
SpUtil.putInt('key', 123);
SpUtil.putBool('key', true);

// 读取数据
String value = SpUtil.getString('key');
int num = SpUtil.getInt('key');
bool flag = SpUtil.getBool('key');

// 删除数据
SpUtil.remove('key');
```

### 开发者工具

```dart
// 启用开发者模式
DevConfig.instance.enableDevMode();

// 设置代理
DevConfig.instance.setProxy('192.168.1.100', 8888);

// 查看网络请求记录
Go().push(DeveloperPage());
```

## 最佳实践

### 1. 页面创建模板

```dart
// my_page.dart
class MyPage extends BaseStatefulMvvmWidget {
  final String id;
  
  MyPage({required this.id});

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends BaseMvvmState<MyViewModel, MyPage> {
  @override
  MyViewModel createViewModel() => MyViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('我的页面'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget? buildLoadingContentView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.title),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: viewModel.requestData,
            child: Text('刷新数据'),
          ),
        ],
      ),
    );
  }

  @override
  void onRetryClick() {
    viewModel.requestData();
  }
}

// my_view_model.dart
class MyViewModel extends BaseViewModel {
  final String id;
  
  MyViewModel(BuildContext context, {required this.id}) : super(context);

  String title = '';

  @override
  void init() {
    // 初始化
  }

  @override
  void onCreated() {
    requestData();
  }

  Future<void> requestData() async {
    showLoadingDialog();
    try {
      var data = await HttpGo.instance.getData(
        'https://api.example.com/data/$id',
      );
      title = data['title'];
      hideDialog();
      showContent();
    } catch (e) {
      hideDialog();
      showErrorState(e.toNetError());
    }
  }
}
```

### 2. 列表页创建模板

```dart
// list_page.dart
class ListPage extends BaseStatefulMvvmWidget {
  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends BaseMvvmListState<ListViewModel, ListPage> {
  @override
  ListViewModel createViewModel() => ListViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('列表页'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createItemWidget(int index) {
    var item = viewModel.listItems[index];
    return ListTile(
      leading: ImageLoad(item.avatar),
      title: CommonText(item.name),
      subtitle: CommonText(item.description),
      onTap: () => Go().push(DetailPage(id: item.id)),
    );
  }

  @override
  bool get canPullUp => true;
}

// list_view_model.dart
class ListViewModel extends BaseListViewModel<ListItem> {
  ListViewModel(BuildContext context) : super(context);

  @override
  Future<List<ListItem>> requestListData() async {
    var data = await HttpGo.instance.getData(
      'https://api.example.com/list',
      params: {'page': page, 'pageSize': pageLength},
    );
    return (data['list'] as List)
        .map((e) => ListItem.fromJson(e))
        .toList();
  }

  @override
  void onCreated() {
    super.onCreated();
    requestRefresh(showAni: false);
  }
}
```

### 3. 应用初始化

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化存储
  await SpUtil.getInstance();
  
  // 初始化开发者工具
  DevConfig.instance.init();
  
  // 初始化全局加载视图
  LoadingViewPlugin.initGlobeLoading(
    loadingWidget: Center(child: CircularProgressIndicator()),
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      navigatorKey: NavigateService.getInstance().key, // 必须配置
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/list': (context) => ListPage(),
      },
    );
  }
}
```

## 依赖说明

| 依赖 | 用途 |
|------|------|
| `provider` | 状态管理 |
| `dio_net_work` | 网络请求 |
| `pull_to_refresh` | 下拉刷新/上拉加载 |
| `event_bus` | 消息总线 |
| `shared_preferences` | 本地存储 |
| `cached_network_image` | 网络图片缓存 |
| `ftoast` | Toast 弹窗 |
| `flutterlifecyclehooks` | 生命周期钩子 |
| `photo_view` | 图片预览 |
| `flutter_datetime_picker` | 时间选择器 |

## 常见问题

### Q: 如何在没有 Context 的情况下导航？

A: 使用 `NavigateService.getInstance()` 单例：
```dart
NavigateService.getInstance().push(MyPage());
NavigateService.getInstance().pop();
```

### Q: 如何自定义加载视图？

A: 使用 `LoadingViewPlugin.initGlobeLoading()` 进行全局设置，或使用 `addLoadingWidget()` 进行页面级设置。

### Q: 如何在页面间传递数据？

A: 通过构造函数传递参数，或通过 `Go().push(MyPage(id: '123'))` 传递。

### Q: 如何处理网络错误？

A: 在 ViewModel 中使用 `try-catch` 捕获异常，调用 `showErrorState(e.toNetError())` 显示错误视图。

### Q: 如何实现下拉刷新和上拉加载？

A: 继承 `BaseMvvmListState`，实现 `createItemWidget()` 方法，框架自动处理分页逻辑。

---

**框架作者**: kzCai  
**仓库地址**: https://github.com/c786909486/base_flutter_plugin  
**版本**: 1.0.0  
**SDK 要求**: Dart >=2.12.0 <4.0.0 (空安全)