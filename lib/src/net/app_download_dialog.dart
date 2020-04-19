import 'package:base_flutter/base_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef onFinish = Function(String path);
typedef onError = Function(String error);
class AppDownloadDialog extends StatefulWidget{
  final String url;
  final String path;
  final onFinish finishListener;
  final onError errorlistener;


  AppDownloadDialog(this.url, this.path, this.finishListener, this.errorlistener);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AppDownloadState();
  }

}

class AppDownloadState extends State<AppDownloadDialog>{
  var process = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20,right: 20),
            //限制进度条的高度
            height: 6.0,
            //限制进度条的宽度
            child: new LinearProgressIndicator(
              //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                value: process,
                //背景颜色
                backgroundColor: Colors.grey,
                //进度颜色
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
          ),
        ],
      ),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      var data = Dio().download(widget.url, widget.path, onReceiveProgress: (progress,total){
        setState(() {
          process = progress/total;
        });
        if(progress == total){
          Navigator.pop(context);
          widget.finishListener(widget.path);
        }
      });
    }catch(e){
      Navigator.pop(context);
      widget.errorlistener(e.toString());
    }

  }

}