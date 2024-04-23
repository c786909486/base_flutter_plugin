import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/dev/net_proxy_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeveloperPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DeveloperState();
  
}

class _DeveloperState extends State<DeveloperPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("开发者"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconTitleTextWidget('网络代理',arrow: Icon(Icons.keyboard_arrow_right_sharp),).onTap(() {
              Go().push(NetProxyPage());
            })
          ],
        ),
      ),
    );
  }
  
}