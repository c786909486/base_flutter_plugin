
import 'package:base_flutter/src/base_mvp/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 加载中的弹框
class ProgressDialog extends BaseWidget{

  const ProgressDialog({
    Key key,
    this.hintText
  }) : super(key: key);

  final String hintText;

  @override
  State<BaseWidget> createState() {

    return ProgressDialogState();
  }




}

class ProgressDialogState extends BaseState<ProgressDialog>{
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
                data: ThemeData(
                    cupertinoOverrideTheme: CupertinoThemeData(
                        brightness: Brightness.dark // 局部指定夜间模式，加载圈颜色会设置为白色
                    )
                ),
                child: const CupertinoActivityIndicator(radius: 14.0),
              ),
              Container(height: 8,),
              Text(widget.hintText, style: const TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }

}