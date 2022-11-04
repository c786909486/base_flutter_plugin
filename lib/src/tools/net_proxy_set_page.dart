import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class NetProxySetPage extends BaseStatefulMvvmWidget{
  @override
  State<StatefulWidget> createState() => _NetProxySetState();

}

class _NetProxySetState extends BaseMvvmState<NetProxyViewModel,NetProxySetPage>{
  @override
  Widget? buildLoadingContentView() {
    return viewModel.contentView();
  }

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: AppBar(title: Text("代理设置"),),
      body: loadingContentWidget,
    );
  }

  @override
  NetProxyViewModel createViewModel() {
    return NetProxyViewModel(context);
  }

  @override
  void onRetryClick() {
  }

}



class NetProxyViewModel extends BaseViewModel{
  NetProxyViewModel(BuildContext context) : super(context);

  Widget contentView(){
    return ListView(
      children: [
        Row(
          children: [
            CommonText('是否开启网络代理'),
            Switch(value: NetConfig.canProxy, onChanged: (value){
              NetConfig.canProxy = value;
              notifyListeners();
            })
          ],
        ).addToContainer(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 15))
      ],
    );
  }

}

class NetConfig{
  static bool canProxy = false;
}