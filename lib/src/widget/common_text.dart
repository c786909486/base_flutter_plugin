import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Text CommonText(String text,
    {Color textColor = Colors.black,
      double textSize = 16,
      TextAlign textAlign = TextAlign.start,FontWeight fontWeight = FontWeight.normal}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(color: textColor, fontSize: textSize,fontWeight: fontWeight),
  );
}
