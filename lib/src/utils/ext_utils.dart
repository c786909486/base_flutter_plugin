import 'dart:convert';

import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


extension StringExt on String{

  ///json字符串转map
  Map<String,dynamic> toMap(){
    return jsonDecode(this);
  }

  ///判断字符串是否是数字
  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  ///判断是否为null或空值
  bool isNullOrEmpty(){
    if(this==null||this.isEmpty){
      return true;
    }else{
      return false;
    }
  }
}

extension MapExt on Map{
  Map<String,dynamic> toJsonMap(){
    return RequestParams(this);
  }
}

///double适配屏幕尺寸
extension DoubleExt on double{
  num fitWidth() {
    return ScreenUtil.getInstance().setWidth(this.toDouble());
  }

  num fitHeight() {
    return ScreenUtil.getInstance().setHeight(this.toDouble());
  }

  num fitSp(){
    return ScreenUtil.getInstance().setSp(this.toDouble());
  }



}

///widget拓展方法
extension WidgetExt on Widget{

  ///添加布局到Container
  Widget addToContainer({
    Key key,
    Alignment alignment,
    EdgeInsetsGeometry padding,
    Color color,
    Decoration decoration,
    Decoration foregroundDecoration,
    double width,
    double height,
    BoxConstraints constraints,
    EdgeInsetsGeometry margin,
    Matrix4 transform,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
        key: key,
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        clipBehavior: clipBehavior,
        child: this);
  }

  ///设置Colunm和Row控件权重
  Widget setWeight(int weight){
    return Expanded(flex: weight,child: this,);
  }

  ///widget点击事件
  Widget onTap(GestureTapCallback onTap,{Key key,

    GestureTapCallback onDoubleTap,
    GestureLongPressCallback onLongPress,
    GestureTapDownCallback onTapDown,
    GestureTapCancelCallback onTapCancel,
    ValueChanged<bool> onHighlightChanged,
    ValueChanged<bool> onHover,
    Color focusColor,
    Color hoverColor,
    Color highlightColor = Colors.transparent,
    Color splashColor,
    InteractiveInkFeatureFactory splashFactory,
    //radius=0 无波纹效果
    double radius=0,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool> onFocusChange,
    bool autofocus = true,}) {
    FocusNode defaultNode = new FocusNode();
    return InkWell(
        child: this,
        onTap: (){
          onTap();
          if(focusNode==null){
            defaultNode.requestFocus();
          }
        },
        onDoubleTap:onDoubleTap,
        onLongPress:onLongPress,
        onTapDown:onTapDown,
        onTapCancel:onTapCancel,
        onHighlightChanged:onHighlightChanged,
        onHover:onHover,
        focusColor:focusColor,
        hoverColor:hoverColor,
        highlightColor:highlightColor,
        splashColor:splashColor,
        splashFactory:splashFactory,
        radius:radius,
        borderRadius:borderRadius,
        customBorder:customBorder,
        enableFeedback:enableFeedback,
        excludeFromSemantics:excludeFromSemantics,
        focusNode:focusNode??defaultNode,
        canRequestFocus:canRequestFocus,
        onFocusChange:onFocusChange,
        autofocus:autofocus);
  }


  ///转圆角
  Widget toRound({BorderRadius borderRadius = BorderRadius.zero,CustomClipper<RRect> clipper, Clip clipBehavior = Clip.antiAlias}){
    return ClipRRect(
      borderRadius: borderRadius,clipBehavior: clipBehavior,
      clipper: clipper,
      child: this,
    );
  }

  Widget setLocation({double left,double right,double top,double bottom}){
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: this,
    );
  }

}

