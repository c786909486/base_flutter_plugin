// 列表页模板（base_flutter：下拉刷新 + 上拉加载更多）
//
// 用法：复制到 lib/pages/xxx/xxx_list_page.dart，按业务替换类名、模型与接口。
// 能力：SmartRefresher 下拉刷新、上拉加载、分页 page/pageLength、
//       空数据空态、错误态 + 点击重试、固定行高优化。
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

class UserListPage extends BaseStatefulMvvmWidget {
  const UserListPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserListPageState();
}

class _UserListPageState
    extends BaseMvvmListState<UserListViewModel, UserListPage> {
  @override
  UserListViewModel createViewModel() => UserListViewModel(context);

  // 可选：自定义加载中的占位 UI（不写则使用基类默认的转圈）。
  @override
  void onCreate() {
    super.onCreate();
    addLoadingWidget(
      loadingWidget: (context, msg) =>
          const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('用户列表'),
      body: loadingContentWidget,
    );
  }

  // 需要上拉加载更多时显式开启（默认 false）。
  @override
  bool get canPullUp => true;

  // 固定行高：滚动时跳过测量，性能更好；此时 separatorDivider 不生效。
  // 行高不固定时返回 null，让列表自动布局。
  @override
  double? get itemExtent => 64;

  @override
  EdgeInsets get listPadding => const EdgeInsets.symmetric(horizontal: 16);

  // itemExtent 为 null 时才会使用该分隔线。
  @override
  Widget get separatorDivider => const Divider(height: 1);

  @override
  Widget createItemWidget(int index) {
    final user = viewModel.listItems[index];
    return Row(
      children: [
        Expanded(child: CommonText(user.name)),
        CommonText(user.phone, textColor: Colors.grey, textSize: 13),
      ],
    )
        .addToContainer(padding: const EdgeInsets.symmetric(vertical: 12))
        .onTap(() => Go().push(UserDetailPage(params: {'id': user.id})));
  }
}

class UserListViewModel extends BaseListViewModel<User> {
  UserListViewModel(super.context);

  @override
  void onCreated() {
    super.onCreated(); // 必须：基类在此创建 RefreshController
    requestRefresh(showAni: false); // 首次进入加载第一页
  }

  @override
  Future<List<User>> requestListData() async {
    // page 从 1 开始：requestRefresh 会重置为 1，requestLoadMore 沿用当前 page；
    // pageLength 默认 20。把当前页数据返回即可，基类负责替换/追加 listItems。
    // TODO: 替换为真实接口与返回结构
    final map = await HttpGo.instance.getData('/api/users', data: {
      'page': page,
      'pageSize': pageLength,
    });
    final list = (map['list'] as List? ?? [])
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }
}

// 示例模型，按业务替换。
class User {
  final int id;
  final String name;
  final String phone;

  const User({required this.id, required this.name, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int? ?? 0,
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
      );
}

// 列表项点击后的详情页占位，避免复制模板后缺少该类。
class UserDetailPage extends BaseStatefulMvvmWidget {
  const UserDetailPage({super.key, super.params});

  @override
  State<StatefulWidget> createState() => _UserDetailPageState();
}

class _UserDetailPageState
    extends BaseMvvmState<CommonViewModel, UserDetailPage> {
  @override
  CommonViewModel createViewModel() => CommonViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('用户详情'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget? buildLoadingContentView() {
    return Center(child: CommonText('id = ${widget.params?['id']}'));
  }

  @override
  void onRetryClick() {}
}
