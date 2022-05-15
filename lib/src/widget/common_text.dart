import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_flutter/base_flutter.dart';

Widget CommonText(String? text,
    {Color textColor = Colors.black,
    double textSize = 16,
    String hintText = "",
    Color hintColor = Colors.grey,
    TextAlign textAlign = TextAlign.start,
    double height = 1,
    FontWeight fontWeight = FontWeight.normal,
    bool canCopy = false}) {
  return canCopy ? SelectableText(
    text.isNullOrEmpty() ? hintText : text ?? "",
    textAlign: textAlign,
    style: TextStyle(
        color: text.isNullOrEmpty() ? hintColor : textColor,
        fontSize: textSize,
        height: height,
        fontWeight: fontWeight),
  ):Text(
    text.isNullOrEmpty() ? hintText : text ?? "",
    textAlign: textAlign,
    style: TextStyle(
        color: text.isNullOrEmpty() ? hintColor : textColor,
        fontSize: textSize,
        height: height,
        fontWeight: fontWeight),
  );
}
