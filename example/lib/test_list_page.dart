import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestListPage extends BaseStatefulMvvmWidget{
  @override
  State<StatefulWidget> createState() => _TestListState();
  
}

class _TestListState extends BaseMvvmListState<TestListViewModel,TestListPage>{

  @override
  void initState() {
    super.initState();
    addLoadingWidget(loadingWidget: (str){
      return CommonText('加载中。。。').addToContainer(height: 100);
    });
  }

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: AppBar(title: Text('测试列表'),),
      body: loadingContentWidget,
      floatingActionButton: FloatingActionButton(onPressed: (){
        viewModel.requestRefresh();
      },child: Icon(Icons.refresh,color: Colors.white,),),
    );
  }

  @override
  bool get touchOutDismiss => true;


  @override
  Widget createItemWidget(int index) {
    return CommonText("123123").addToContainer(height: 50,alignment: Alignment.center).onTap(() {
      viewModel.requestRefresh();
    });
  }

  @override
  TestListViewModel createViewModel() {
    return TestListViewModel(context);
  }

  @override
  bool get backDismiss => true;
}


class TestListViewModel extends BaseListViewModel<String>{
  TestListViewModel(super.context);

  @override
  Future<List<String>> requestListData() async {
    await Future.delayed(Duration(seconds: 2));
    return Future(() => ['','','','']);
  }
  
  @override
  void onCreated() {
    super.onCreated();
    requestRefresh(showAni: false);
  }

  
}