import 'dart:convert';

import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension DateExt on DateTime {
  String toDateStr(List<String> format, {LocaleType locale = LocaleType.zh}) {
    return formatDate(this, format, locale);
  }

  DateTime get firstDay {
    var first = DateTime(
      this.year,
      this.month,
      1,
    );
    return first;
  }
}

extension StringExt on String {
  ///json字符串转map
  Map<String, dynamic> toMap() {
    return jsonDecode(this);
  }

  ///判断字符串是否是数字
  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  Pattern toReg() {
    return RegExp(this);
  }

  ///判断是否为null或空值
  bool isNullOrEmpty() {
    if (this == null || this.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool trimIsNullOrEmpty() {
    if (this == null || this.isEmpty) {
      return true;
    } else {
      if (this.trim().isEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  double? toDouble() {
    return double.tryParse(this);
  }

  int? toInt() {
    return int.tryParse(this);
  }

  DateTime? toDate() {
    return DateTime.tryParse(this);
  }
}


extension StringExt2 on String? {
  ///json字符串转map
  Map<String, dynamic>? toMap() {
    if (this.isNullOrEmpty()) {
      return null;
    }
    return jsonDecode(this!);
  }

  ///判断字符串是否是数字
  bool isNumeric() {
    if (this == null) {
      return false;
    }
    return double.tryParse(this!) != null;
  }

  ///判断是否为null或空值
  bool isNullOrEmpty() {
    if (this == null || this!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool trimIsNullOrEmpty() {
    if (this == null || this!.isEmpty) {
      return true;
    } else {
      if (this!.trim().isEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }
}



///double适配屏幕尺寸
extension DoubleExt on double {

  Radius get radius => Radius.circular(this);

  BorderRadius get borderRadius => BorderRadius.circular(this);
}

extension IntExt on int {

  Radius get radius => Radius.circular(this.toDouble());

  BorderRadius get borderRadius => BorderRadius.circular(this.toDouble());

}

extension dynamicExt on dynamic {
  String toNetError() {
    return NetErrorUtils.getNetError(this);
  }
}
///widget拓展方法
extension WidgetExt on Widget {
  ///添加布局到Container
  Widget addToContainer({
    Key? key,
    Alignment? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
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
  Widget setWeight(int weight) {
    return Expanded(
      flex: weight,
      child: this,
    );
  }

  ///widget点击事件
  Widget onTap(
    GestureTapCallback onTap, {
    Key? key,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapCancelCallback? onTapCancel,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    MaterialStateProperty<Color?>? overlayColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    bool? enableFeedback = false,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
        bool requestFocus = true

  }) {
    FocusNode defaultNode = new FocusNode();
    return InkWell(
        child: this,
        onTap: () {
          if(requestFocus){
            (focusNode??defaultNode).requestFocus(FocusNode());
          }

          onTap();
        },
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        onHighlightChanged: onHighlightChanged,
        onHover: onHover,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        splashFactory: splashFactory,
        radius: radius,
        borderRadius: borderRadius,
        customBorder: customBorder,
        enableFeedback: enableFeedback,
        excludeFromSemantics: excludeFromSemantics,
        focusNode: focusNode ?? defaultNode,
        canRequestFocus: canRequestFocus,
        onFocusChange: onFocusChange,
        autofocus: autofocus);
  }

  ///转圆角
  Widget toRound(
      {BorderRadius borderRadius = BorderRadius.zero,
      CustomClipper<RRect>? clipper,
      Clip clipBehavior = Clip.antiAlias}) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      clipper: clipper,
      child: this,
    );
  }

  Widget toCircle(
      {double borderWidth = 0, Color borderColor = Colors.transparent}) {
    return ClipOval(
      child: this,
    ).addToContainer(
        padding: EdgeInsets.all(borderWidth),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: borderColor, shape: BoxShape.circle));
  }

  Widget setLocation(
      {double? left, double? right, double? top, double? bottom}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: this,
    );
  }
}

removeFocus(BuildContext context){
  FocusScope.of(context).unfocus();
}
