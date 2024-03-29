import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DateTimePickerTheme with Diagnosticable {
  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle itemStyle;
  final TextStyle titleStyle;
  final Color? backgroundColor;

  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  final String title;
  final String doneText;
  final String cancelText;


  const DateTimePickerTheme({
    this.cancelStyle = const TextStyle(color: Colors.black54, fontSize: 16),
    this.doneStyle = const TextStyle(color: Colors.blue, fontSize: 16),
    this.itemStyle = const TextStyle(color: Color(0xFF000046), fontSize: 18),
    this.backgroundColor = Colors.white,
    this.title = "",
    this.titleStyle = const TextStyle(color: Colors.black, fontSize: 18),
    this.cancelText = "取消",
    this.doneText = "确定",
    this.containerHeight = 210.0,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
  });
}
