
import 'package:flutter/cupertino.dart';
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
        timeInSecForIos: 1,
        fontSize: 16.0
    );
  }



}

