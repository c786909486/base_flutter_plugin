// 可刷新滑动页面模板（base_flutter：任意滚动组件 + 下拉刷新）
//
// 用法：复制到 lib/pages/xxx/xxx_page.dart，按业务替换类名、模型与接口。
// 关键点：ViewModel 必须继承 BaseListViewModel；滚动组件必须加
//         AlwaysScrollableScrollPhysics，否则内容不足一屏时无法下拉。
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

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
      appBar: CommonAppBar('首页'),
      body: loadingContentWidget,
    );
  }

  // 返回任意滚动组件，外层会自动套 SmartRefresher 实现下拉刷新。
  // 需要上拉加载时重写 canPullUp => true，并让接口按 page/pageLength 分页。
  @override
  Widget createScrollWidget() {
    final home = viewModel.home;
    return ListView(
      // 关键：内容不足一屏时也能下拉刷新。
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        CommonText('欢迎回来', textSize: 22, fontWeight: FontWeight.bold),
        const SizedBox(height: 16),
        for (final banner in home.banners)
          CommonText(banner).addToContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: 8.borderRadius,
            ),
          ),
        for (final tile in home.tiles)
          CommonText(tile)
              .addToContainer(padding: const EdgeInsets.symmetric(vertical: 14))
              .onTap(() => viewModel.showToast('点击了 $tile')),
      ],
    );
  }
}

class HomeViewModel extends BaseListViewModel<HomeData> {
  HomeViewModel(super.context);

  HomeData? _home;

  HomeData get home => _home ?? HomeData.empty();

  @override
  void onCreated() {
    super.onCreated(); // 必须：基类在此创建 RefreshController
    requestRefresh(showAni: false); // 首次进入加载
  }

  @override
  Future<List<HomeData>> requestListData() async {
    // TODO: 替换为真实接口
    final map = await HttpGo.instance.getData('/api/home');
    _home = HomeData.fromJson(map);
    // BaseListViewModel 要求返回 List：整页数据用单元素承载。
    // 返回空列表会进入“暂无数据”空态，所以这里始终返回非空。
    return [_home!];
  }
}

// 示例数据模型，按业务替换。
class HomeData {
  final List<String> banners;
  final List<String> tiles;

  const HomeData({required this.banners, required this.tiles});

  factory HomeData.empty() => const HomeData(banners: [], tiles: []);

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        banners: (json['banners'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        tiles:
            (json['tiles'] as List? ?? []).map((e) => e.toString()).toList(),
      );
}
