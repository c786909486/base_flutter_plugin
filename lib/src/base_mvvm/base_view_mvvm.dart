

abstract class IBaseMvvmView {
  ///显示加载页面
  void showLoading();
  ///显示错误页面
  void showErrorPage(String error);
  ///显示无数据空白页面
  void showEmpty();
  ///显示内容页面
  void showContent();
  ///弹出toast
  void showToast(String msg);
  ///加载弹窗
  void showLoadingDialog(String msg);
  ///关闭加载弹窗
  void hideDialog();
  /// 结束刷新
  void finishRefresh();
  /// 结束加载更多
  void finishLoadMore();
}