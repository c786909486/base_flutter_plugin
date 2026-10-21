import 'package:base_flutter/base_flutter.dart';
import 'package:example/view_model/list_example_list_view_model.dart';
import 'package:flutter/material.dart';

/// 网络请求列表示例。
///
/// - 数据来自 `RequestNetModel.requestList`（HttpGo GET 封装，
///   见 lib/model/request_net_model.dart）。
/// - 下拉刷新、上拉加载更多、分页、空态/错误态、点击重试均由框架自动处理。
/// - 接口 baseUrl / token 请求头在 main.dart 的 initNet() 中统一配置。
class ListExample extends BaseStatefulMvvmWidget {
  const ListExample({super.key});

  @override
  State<StatefulWidget> createState() => _ListExampleState();
}

class _ListExampleState
    extends BaseMvvmListState<ListExampleListViewModel, ListExample> {
  @override
  ListExampleListViewModel createViewModel() =>
      ListExampleListViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('网络列表示例', actions: [
        CommonText('提交')
            .addToContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16),
            )
            .onTap(() => viewModel.submitDemo()),
      ]),
      body: loadingContentWidget,
    );
  }

  /// 上拉加载更多（默认关闭，需要显式开启）。
  @override
  bool get canPullUp => true;

  /// 固定行高：滚动时跳过测量，性能更好。
  @override
  double? get itemExtent => 56;

  @override
  EdgeInsets get listPadding => const EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget createItemWidget(int index) {
    final item = viewModel.listItems[index];
    return CommonText('${item['name'] ?? item['title'] ?? item}')
        .addToContainer(padding: const EdgeInsets.symmetric(vertical: 12))
        .onTap(() => viewModel.showToast('点击了第 ${index + 1} 条'));
  }
}
