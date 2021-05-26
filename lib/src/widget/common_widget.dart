import 'package:flutter/material.dart';
import '../utils/ext_utils.dart';
import 'clear_text_field.dart';

AppBar CommonAppBar(String title,
    {List<Widget>? actions,
      Color? textColor,
      double? fontSize,
      FontWeight? fontWeight,
      Widget? leading,
      double elevation = 0.5,
      bool centerTitle = true,
      String? fontFamily,
      IconThemeData? iconTheme,
      Key? key}) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: centerTitle,
    elevation: elevation,
    automaticallyImplyLeading: true,
    iconTheme: iconTheme ?? IconThemeData(color: Colors.black),
    key: key,
    title: Text(
      title,
      style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 17.0.fs(),
          fontWeight: fontWeight ?? FontWeight.bold,
          fontFamily: fontFamily),
    ),
    actions: actions,
    leading: leading,
  );
}

Widget createInput(String text, ITextFieldCallBack fieldCallBack,
    {String hintText = "请输入",
      ITextInputType keyboardType = ITextInputType.text,
      int weight = 3}) {
  FocusNode node = new FocusNode();
  return ITextField(
    inputText: text,
    hintText: "请输入",
    // focusNode: node,
    textStyle: TextStyle(color: Colors.black, fontSize: 28.0.fs()),
    keyboardType: keyboardType,
    textInputAction: TextInputAction.next,
    hintStyle: TextStyle(fontSize: 28.0.fs(), color: Color(0xFF646566)),
    fieldCallBack: fieldCallBack,
    inputBorder: OutlineInputBorder(borderSide: BorderSide.none),
    textAlign: TextAlign.right,
    needDelete: false,
    autofocus: false,
    // onSubmitted: (content) {
    //   node.unfocus();
    // },
    contentPadding: EdgeInsets.all(0),
  ).setWeight(weight);
  // var controller = TextEditingController.fromValue(TextEditingValue(
  //     text: text, selection: TextSelection.collapsed(offset: text.length)));
  // return TextField(
  //   controller: controller,
  //   focusNode: node,
  //   style: TextStyle(color: ColorRes.text_black, fontSize: 28.0.fs()),
  //   decoration: InputDecoration(
  //     hintText: hintText,
  //     border: OutlineInputBorder(borderSide: BorderSide.none),
  //     hintStyle:
  //     TextStyle(fontSize: 28.0.fs(), color: ColorRes.item_title_color),
  //   ),
  //   textAlign: TextAlign.right,
  // )
}

Widget createNormalInput(
    String text,
    ITextFieldCallBack fieldCallBack, {
      String hintText = "请输入",
      TextInputType keyboardType = TextInputType.text,
      TextAlign? textAlign = TextAlign.right,
      int weight = 3,
    }) {
  FocusNode node = new FocusNode();
  TextEditingController controller = TextEditingController.fromValue(
      TextEditingValue(
          text: text,
          selection: new TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream, offset: text.length))));
  return weight == 0
      ? TextField(
    controller: controller,

    // focusNode: node,
    style: TextStyle(color: Colors.black, fontSize: 28.0.fs()),
    keyboardType: keyboardType,
    textInputAction: TextInputAction.next,
    onChanged: fieldCallBack,
    textAlign: textAlign??TextAlign.right,
    autofocus: false,
    // onSubmitted: (content) {
    //   node.unfocus();
    // },
    decoration: InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      hintText: "请输入",
      contentPadding: EdgeInsets.all(0),
      hintStyle: TextStyle(fontSize: 28.0.fs(), color: Color(0xFF646566)),
    ),
  )
      : TextField(
    controller: controller,

    // focusNode: node,
    style: TextStyle(color: Colors.black, fontSize: 28.0.fs()),
    keyboardType: keyboardType,
    textInputAction: TextInputAction.next,
    onChanged: fieldCallBack,
    textAlign: textAlign??TextAlign.right,
    autofocus: false,

    decoration: InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      hintText: "请输入",
      contentPadding: EdgeInsets.all(0),
      hintStyle: TextStyle(fontSize: 28.0.fs(), color: Color(0xFF646566)),
    ),
  ).setWeight(weight);
}
