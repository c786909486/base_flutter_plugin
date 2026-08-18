# Base Flutter Generator

一个 VSCode 扩展，用于快速生成基于 Base Flutter 框架的 MVVM 架构页面。

## 功能

- 在文件栏右键菜单中添加 "[Base] New Page" 选项
- 支持输入页面名称和 ViewModel 名称
- 支持选择 ViewModel 类型（BaseViewModel / BaseListViewModel）
- 支持选择页面类型（basePage / listPage / refreshPage）
- 自动生成下划线命名的文件名和大驼峰命名的类名

## 使用方法

1. 在文件栏中右键点击任意文件或文件夹
2. 选择 "[Base] New Page"
3. 输入页面名称（例如：`home_page`）
4. 输入 ViewModel 名称（例如：`home_view_model`）
5. 选择 ViewModel 类型
6. 选择页面类型
7. 自动生成两个文件：
   - `{page_name}.dart` - 页面文件
   - `{view_model_name}.dart` - ViewModel 文件

## 示例

输入：
- 页面名称：`home_page`
- ViewModel 名称：`home_view_model`
- ViewModel 类型：`BaseViewModel`
- 页面类型：`basePage`

生成文件：
- `home_page.dart` - 包含 `HomePage` 和 `_HomePageState` 类
- `home_view_model.dart` - 包含 `HomeViewModel` 类

## 生成的代码结构

### BaseViewModel 模板
```dart
class HomeViewModel extends BaseViewModel {
  HomeViewModel(BuildContext context) : super(context);

  @override
  void init() { }

  @override
  void onCreated() { }

  Future<void> requestData() async { }
}
```

### BaseListViewModel 模板
```dart
class HomeViewModel extends BaseListViewModel<dynamic> {
  HomeViewModel(BuildContext context) : super(context);

  @override
  Future<List<dynamic>> requestListData() async { }

  @override
  void onCreated() { }
}
```

### basePage 模板
```dart
class HomePage extends BaseStatefulMvvmWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends BaseMvvmState<HomeViewModel, HomePage> {
  @override
  HomeViewModel createViewModel() => HomeViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('HomePage'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget? buildLoadingContentView() { }

  @override
  void onRetryClick() { }
}
```

### listPage 模板
```dart
class HomePage extends BaseStatefulMvvmWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends BaseMvvmListState<HomeViewModel, HomePage> {
  @override
  HomeViewModel createViewModel() => HomeViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('HomePage'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createItemWidget(int index) {
    var item = viewModel.listItems[index];
    return ListTile(
      title: CommonText('Item $index'),
    );
  }

  @override
  bool get canPullUp => true;
}
```

### refreshPage 模板
```dart
class HomePage extends BaseStatefulMvvmWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends BaseMvvmRefreshState<HomeViewModel, HomePage> {
  @override
  HomeViewModel createViewModel() => HomeViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('HomePage'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createScrollWidget() {
    return Column(
      children: [
        const Center(child: Text('Pull down to refresh')),
      ],
    );
  }

  @override
  void onRetryClick() { }
}
```

## 安装

1. 打开 VSCode
2. 按 `Cmd+Shift+P`（Mac）或 `Ctrl+Shift+P`（Windows）
3. 输入 "Install from VSIX"
4. 选择 `base-flutter-generator-1.0.0.vsix` 文件

或者：

1. 在 VSCode 中打开扩展视图（`Cmd+Shift+X`）
2. 点击右上角的 "..." 菜单
3. 选择 "Install from VSIX..."
4. 选择编译好的 `.vsix` 文件

## 开发

1. 克隆仓库
2. 运行 `npm install`
3. 运行 `npm run compile`
4. 按 `F5` 启动扩展开发宿主

## 许可证

MIT License