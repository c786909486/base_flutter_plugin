import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NetProxyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NetProxyState();

}

class _NetProxyState extends State<NetProxyPage>{

  var canProxy = false;

  var host = "";

  var port = "";



  @override
  void initState() {
    super.initState();
    setState(() {
      canProxy = DevConfig.instance.canProxy;
      if(canProxy){
        host = DevConfig.instance.host;
        port = DevConfig.instance.port.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      //web 端浏览器不允许应用层设置代理（上层入口已隐藏，此处兜底防止被直接 push）
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('网络代理'),),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Web 端不支持应用内设置代理\n请使用浏览器开发者工具（DevTools → Network）抓包调试',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("网络代理"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconTitleWidget('是否开启代理',contentWidget: Switch(value: canProxy, onChanged: (value){
              setState(() {
                canProxy = value;
                if(!canProxy){
                  DevConfig.instance.saveProxy(canProxy: canProxy);
                }
              });
            }),showArrow: false,),
            if(canProxy)
            ...[
              SizedBox(height: 20,),
              CommonInput(
                hintText: '请输入代理地址',
                border: InputBorder.none,
                isDense: true,
                padding: EdgeInsets.zero,
                maxLines: 1,
                text: host,
                onChanged: (str){
                  this.host = str;
                },
              ).addToContainer(
                  decoration: BoxDecoration(
                      color: Color(0xfff1f1f1),
                      borderRadius: 10.borderRadius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 13),
                  margin: EdgeInsets.symmetric(horizontal: 16)
              ),

              SizedBox(height: 20,),
              CommonInput(
                hintText: '请输入代理端口',
                border: InputBorder.none,
                isDense: true,
                padding: EdgeInsets.zero,
                maxLines: 1,
                text: port,
                keyboardType: CommonInputType.number,
                onChanged: (str){
                  this.port = str;
                },
              ).addToContainer(
                  decoration: BoxDecoration(
                      color: Color(0xfff1f1f1),
                      borderRadius: 10.borderRadius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 13),
                  margin: EdgeInsets.symmetric(horizontal: 16)
              ),

              SizedBox(height: 20,),
              TextButton(onPressed: (){
                saveProxy();
              }, child: CommonText('确定',textColor: Colors.white),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                shape: WidgetStateProperty.all(StadiumBorder()),
                minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width-32,45))
              ),)
            ]
          ],
        ),
      ),
    );
  }

  Future<void> saveProxy() async {
    if(host.isEmpty){
      ToastUtils.shotToast("请输入代理地址", context: context);
      return;
    }

    if(port.isEmpty){
      ToastUtils.shotToast("请输入代理端口", context: context);
      return;
    }
    await DevConfig.instance.saveProxy(canProxy: canProxy,host: host,port: port.toInt()!);
    Go().pop();
  }

}