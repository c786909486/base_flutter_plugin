import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_flutter/src/utils/ext_utils.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import '../number_textinput_format.dart';

enum CommonInputType {
  text,
  multiline,
  number,
  numberAndDecimal,
  phone,
  datetime,
  emailAddress,
  url,
  password,
  passwordAndNumber,
}
class CommonInput extends StatefulWidget {
  String? text;
  String? hintText;
  String? helpText;
  String? errorText;

  TextStyle? helpTextStyle;
  TextStyle? errorTextStyle;
  InputBorder? errorBorder;
  Widget? counter;
  EdgeInsets? padding;
  double textSize;
  Color? textColor;
  Color? hintColor;
  InputBorder? border;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  int? maxLines;
  Widget? headWidget;
  bool needClear;
  Widget? clearWidget;
  bool? filled;
  bool isCollapsed;
  bool showPassword = false;
  Widget? visiblePasswordWidget;
  Widget? hidePasswordWidget;
  TextAlign textAlign;
  CommonInputType keyboardType;

  // TextType?  textType;

  CommonInput({this.text,
    this.hintText,
    this.helpText,
    this.helpTextStyle,
    this.errorText,
    this.errorTextStyle,
    this.errorBorder,
    this.textSize = 15,
    this.maxLines = 1,
    this.onSubmitted,
    this.onChanged,
    this.border,
    this.hintColor,
    this.textColor,
    this.headWidget,
    this.padding,
    this.counter,
    this.needClear = false,
    this.filled = false,
  this.isCollapsed = false,
    this.showPassword = false,
    this.visiblePasswordWidget,
    this.hidePasswordWidget,
    this.textAlign = TextAlign.start,
  this.keyboardType = CommonInputType.text});

  @override
  State<StatefulWidget> createState() => _CommonInputWidget();
}

class _CommonInputWidget extends State<CommonInput> {
  bool showClear = false;
  String text = "";
  bool _isNumber = false;
  bool _isPassword = false;
  int _offLength = 0;
  TextEditingController? controller;
  TextInputType _keyborder = TextInputType.text;

  @override
  void initState() {
    text = widget.text ?? "";
    _offLength = text.length;
    showClear = text.isNotEmpty;
    _keyborder = _getTextInputType();
    super.initState();
    controller = TextEditingController.fromValue(
        TextEditingValue(
            text: text,
            composing: TextRange.collapsed(0),
            selection: TextSelection.fromPosition(TextPosition(offset: text.length,affinity: TextAffinity.downstream))));
  }

  ///输入类型
  TextInputType _getTextInputType() {
    switch (widget.keyboardType) {
      case CommonInputType.text:
        return TextInputType.text;
      case CommonInputType.multiline:
        return TextInputType.multiline;
      case CommonInputType.number:
        _isNumber = true;
        return TextInputType.number;
      case CommonInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case CommonInputType.numberAndDecimal:
        _isNumber = false;
        return TextInputType.numberWithOptions(decimal: true, signed: true);
      case CommonInputType.datetime:
        return TextInputType.datetime;
      case CommonInputType.emailAddress:
        return TextInputType.emailAddress;
      case CommonInputType.url:
        return TextInputType.url;
      case CommonInputType.password:
        _isPassword = true;
        return TextInputType.text;
      case CommonInputType.passwordAndNumber:
        _isPassword = true;
        _isNumber = true;
        return TextInputType.number;
    }
  }

  ///输入范围
  List<TextInputFormatter>? _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
    ]
        : widget.keyboardType == CommonInputType.numberAndDecimal ?
    <TextInputFormatter>[
      UsNumberTextInputFormatter(),
    ] : null;
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.center,
      alignment: Alignment.center,
      children: [
        TextField(
          controller: controller,
          obscureText: _isPassword,
          keyboardType: _keyborder,
          textAlign: widget.textAlign,
          inputFormatters: _getTextInputFormatter(),
          style: TextStyle(
              fontSize: widget.textSize,
              color: widget.textColor ?? Colors.black),
          decoration: InputDecoration(
              helperText: widget.helpText,
              helperStyle: widget.helpTextStyle,
              errorText: widget.errorText,
              errorStyle: widget.errorTextStyle,
              errorBorder: widget.errorBorder,
              contentPadding: widget.padding,
              filled: widget.filled,
              isCollapsed: widget.isCollapsed,
              counter: widget.counter,
              prefix: widget.headWidget ??
                  Container(
                    width: 0,
                  ),
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///显示密码
                  widget.showPassword?(
                  _isPassword?
                      widget.hidePasswordWidget??Icon(Ionicons.eye):
                      widget.visiblePasswordWidget??Icon(Ionicons.eye_off)
                  ).onTap(() {
                    setState(() {
                      if(_isPassword){
                        _isPassword = false;
                      }else{
                        _isPassword = true;
                      }
                    });
                  }).addToContainer(margin: EdgeInsets.only(
                    right: 8
                  )):Container(width: 0,),

                  ///清除按钮
                  (widget.needClear && showClear)
                      ? (widget.clearWidget ??
                      Icon(
                        Ionicons.close_circle,
                        size: 20,
                      ))
                      .onTap(() {
                    setState(() {
                      text = "";
                      controller!.text = "";
                      _offLength = 0;
                      showClear = false;
                    });
                  })
                      : Container(
                    width: 0,
                  )
                ],
              ),
              hintText: widget.hintText,
              border: widget.border ?? UnderlineInputBorder(),
              hintStyle: TextStyle(
                  fontSize: widget.textSize,
                  color: widget.hintColor ?? Colors.grey)),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {
              _offLength = _offLength+(value.length-text.length);
             text = value;
              if (value.isNullOrEmpty()) {
                showClear = false;
              } else {
                showClear = true;
              }
            });
          },
          onSubmitted: (value) {
            if(widget.onSubmitted!=null){
              widget.onSubmitted!(value);
            }
          },
          maxLines: widget.maxLines,
        ),
      ],
    );
  }
}
