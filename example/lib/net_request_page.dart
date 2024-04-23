import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class NetRequestPage extends BaseStatefulMvvmWidget{
  @override
  State<StatefulWidget> createState() => _NetRequestState();

}

class _NetRequestState extends BaseMvvmState<NetRequestViewModel,NetRequestPage>{
  @override
  Widget? buildLoadingContentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CommonText('设置代理').onTap(() {
            Go().push(DeveloperPage());
          }),

          SizedBox(height: 30,),
          CommonText('网络请求').onTap(() {
            viewModel.requestNet();
          }),
        ],
      ),
    );
  }

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: AppBar(
        title: Text("代理设置"),
      ),
      body: loadingContentWidget,
    );
  }

  @override
  NetRequestViewModel createViewModel() {
    return NetRequestViewModel(context);
  }

  @override
  void onRetryClick() {
  }

}

class NetRequestViewModel extends BaseViewModel{
  NetRequestViewModel(super.context);


  Future<void> requestNet() async {
    showLoadingDialog();
    try{
      await HttpGo.instance.postData("https://saastest.yytong.com/ophApi/customerAskLeave/listBean");
      hideDialog();
    }catch(e){
      showToast(e.toNetError());
      hideDialog();
    }

  }
}