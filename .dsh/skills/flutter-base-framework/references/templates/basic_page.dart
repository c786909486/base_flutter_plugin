// 基础内容页模板（base_flutter MVVM）
//
// 用法：复制到 lib/pages/xxx/xxx_page.dart，按业务替换类名与 TODO 部分。
// 能力：首屏加载态 -> 内容态、错误态 + 点击重试、toast、加载弹窗、
//       onResume/onPause 生命周期、params 路由传参。
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

class DetailPage extends BaseStatefulMvvmWidget {
  const DetailPage({super.key, super.params});

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends BaseMvvmState<DetailViewModel, DetailPage> {
  @override
  DetailViewModel createViewModel() => DetailViewModel(context);

  // 根布局：body 必须使用 loadingContentWidget，才能自动切换加载/空/错误态。
  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('详情页', actions: [
        CommonText('保存')
            .addToContainer(padding: const EdgeInsets.symmetric(horizontal: 16))
            .onTap(() => viewModel.save()),
      ]),
      body: loadingContentWidget,
    );
  }

  // 正文内容（内容态时展示）。
  @override
  Widget? buildLoadingContentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText('id = ${widget.params?['id']}'),
          const SizedBox(height: 12),
          CommonText(
            '标题：${viewModel.title}',
            textSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => viewModel.rename('新的标题'),
            child: const Text('修改标题'),
          ),
        ],
      ),
    );
  }

  // 错误态/空态点击重试。
  @override
  void onRetryClick() => viewModel.loadData();
}

class DetailViewModel extends BaseViewModel {
  DetailViewModel(super.context);

  String title = '';

  // ViewModel 创建完成、页面首次可交互后触发首屏加载。
  @override
  void onCreated() {
    super.onCreated();
    loadData();
  }

  Future<void> loadData() async {
    showLoadingState();
    try {
      // TODO: 替换为真实接口
      final data = await HttpGo.instance.getData('/api/detail', data: {
        'id': 1,
      });
      title = data['title']?.toString() ?? '';
      showContent();
    } catch (e) {
      showErrorState(e.toNetError());
    }
  }

  Future<void> save() async {
    showLoadingDialog();
    try {
      // TODO: 替换为真实提交逻辑
      await Future<void>.delayed(const Duration(milliseconds: 300));
      showToast('保存成功');
    } catch (e) {
      showToast(e.toNetError());
    } finally {
      hideDialog();
    }
  }

  // 修改 VM 状态后必须通知页面重建（不要用 setState）。
  void rename(String value) {
    title = value;
    notifyListeners();
  }
}
