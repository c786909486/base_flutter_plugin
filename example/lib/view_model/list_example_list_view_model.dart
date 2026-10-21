import 'package:base_flutter/base_flutter.dart';
import 'package:example/model/request_net_model.dart';

/// 列表页 ViewModel：混入 RequestNetModel，实现 requestListData 即可。
///
/// 下拉刷新、上拉加载更多、分页、空态/错误态由
/// BaseListViewModel + BaseMvvmListState 自动处理。
class ListExampleListViewModel extends BaseListViewModel<dynamic>
    with RequestNetModel {
  ListExampleListViewModel(super.context);

  @override
  Future<List<dynamic>> requestListData() {
    // page 从 1 开始：下拉刷新重置为 1，上拉加载沿用当前 page。
    return requestList(page: page, rows: pageLength);
  }

  @override
  void onCreated() {
    super.onCreated(); // 必须：创建 RefreshController
    requestRefresh(showAni: false); // 首次进入加载第一页
  }

  /// 提交类请求示例：加载弹窗 + 失败 toast。
  Future<void> submitDemo() async {
    showLoadingDialog();
    try {
      await requestSubmit(id: 1, info: 'demo');
      showToast('提交成功');
      // 提交成功后如需刷新列表：requestRefresh(showAni: false);
    } catch (e) {
      showToast(e.toNetError());
    } finally {
      hideDialog();
    }
  }
}
