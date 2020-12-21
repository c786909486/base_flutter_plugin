
import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/utils/utils.dart';
import 'package:base_flutter/src/widget/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'BasePresenter.dart';
import 'IBaseView.dart';

enum PageStatus{
  loading,
  showData,
  error,
  empty
}

abstract class BaseWidget extends StatefulWidget{

  final Map<String,dynamic> params;

  const BaseWidget({Key key,this.params}): super(key: key);

  @override
  State<BaseWidget> createState();

}

abstract class BaseState< T extends BaseWidget> extends State<T> implements IBaseView{


  List<BasePresenter> presenterList;

  String error;

  bool _isShowDialog = false;

  PageStatus status = PageStatus.loading;

  @override
  Widget build(BuildContext context);

  @override
  void initState() {
    presenterList = new List();
    super.initState();

  }

  void addPresenter(BasePresenter presenter){
    presenter.attach(this);
    presenterList.add(presenter);
  }

  void addPresenters(List<BasePresenter> presenters){
    for(BasePresenter presenter in presenters){
      presenter.attach(this);
    }
    presenterList.addAll(presenters);
  }

  @override
  void dispose() {
    super.dispose();
    for(BasePresenter presenter in presenterList){
      presenter.detach();
    }
    presenterList.clear();
    presenterList = null;
  }


  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void showEmpty() {
    setState(() {
      status = PageStatus.empty;
    });
  }

  @override
  void showErrorPage(String error) {
    this.error = error;
    setState(() {
      status = PageStatus.error;
    });
  }

  @override
  void showLoading() {
    setState(() {
      status = PageStatus.loading;
    });
  }



  @override
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      gravity: ToastGravity.CENTER
    );
  }


  @override
  void hideDialog() {
    if(mounted&&_isShowDialog){
      _isShowDialog = false;
      NavigateService.getInstance().pop();
    }
  }

  @override
  void showLoadingDialog({String msg = "加载中..."}) {
    if(mounted&&!_isShowDialog){
      try{
        showTransparentDialog(
            context: context,
            barrierDismissible: false,
            builder:(context) {
              _isShowDialog = true;
              return WillPopScope(
                onWillPop: () async {
                  // 拦截到返回键，证明dialog被手动关闭
                  onCloseDialog();
                  return Future.value(true);
                },
                child:  ProgressDialog(hintText: msg),
              );
            }
        );
      }catch(e){
        /// 异常原因主要是页面没有build完成就调用Progress。
        print(e);
      }
    }
  }

//  Widget createContentWidget(){
//    if(status == PageStatus.loading){
//
//    }
//  }

  void onCloseDialog(){

  }

}

