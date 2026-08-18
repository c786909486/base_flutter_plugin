import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 加载中的弹框
class ProgressDialog extends StatefulWidget{

  const ProgressDialog({
    Key? key,
    this.hintText
  }) : super(key: key);

  final String? hintText;

  @override
  State<ProgressDialog> createState() {

    return ProgressDialogState();
  }




}

class ProgressDialogState extends State<ProgressDialog>{
  ///静态缓存，避免每次build新建ThemeData
  static final ThemeData _darkTheme = ThemeData(
      cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark // 局部指定夜间模式，加载圈颜色会设置为白色
      )
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 88.0,
          width: 120.0,
          decoration: ShapeDecoration(
              color: const Color(0xFF3A3A3A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Theme(
                data: _darkTheme,
                child: const CupertinoActivityIndicator(radius: 14.0,color: Colors.white,),
              ),
              Container(height: 8,),
              Text(widget.hintText??"", style: const TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }

}