
import 'package:flutter/cupertino.dart';

abstract class IBaseView {
  //显示加载页面
  void showLoading();
  //显示错误页面
  void showErrorPage(String error);
  //显示无数据空白页面
  void showEmpty();
  //获取上下文
  BuildContext getContext();
  //弹出toast
  void showToast(String msg);

  void showLoadingDialog({String msg = "加载中..."});

  void hideDialog();
}