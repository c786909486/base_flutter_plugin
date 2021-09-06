import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_flutter/base_flutter.dart';

Text CommonText(String? text,
    {Color textColor = Colors.black,
      double textSize = 16,
      String hintText = "",
      Color hintColor = Colors.grey,
      TextAlign textAlign = TextAlign.start,FontWeight fontWeight = FontWeight.normal}) {
  return Text(
    text.isNullOrEmpty()?hintText:text??"",
    textAlign: textAlign,
    style: TextStyle(color: text.isNullOrEmpty()?hintColor:textColor, fontSize: textSize,fontWeight: fontWeight),
  );
}
