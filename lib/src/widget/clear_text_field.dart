import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'number_textinput_format.dart';


///自带删除的ITextField
typedef void ITextFieldCallBack(String content);

enum ITextInputType {
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

class ITextField extends StatefulWidget {
  final ITextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final String hintText;
  final TextStyle hintStyle;
  final ITextFieldCallBack fieldCallBack;
  final Icon deleteIcon;
  final InputBorder inputBorder;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onSubmitted;
  final FocusNode focusNode;
  final bool autofocus;
  final bool needDelete;
  final EdgeInsets contentPadding;
  final String labelText;
  String inputText;

  ITextField(
      {Key key,
      ITextInputType keyboardType: ITextInputType.text,
      this.maxLines = 1,
      this.maxLength,
      this.hintText,
      this.hintStyle,
      this.fieldCallBack,
      this.deleteIcon,
      this.inputBorder,
      this.textStyle,
      this.prefixIcon,
      this.validator,
      this.textInputAction,
      this.onSubmitted,
      this.focusNode,
      this.autofocus = true,
      this.contentPadding,
      this.inputText = "",
        this.labelText,
      this.needDelete = true})
      : assert(maxLines == null || maxLines > 0),
        assert(maxLength == null || maxLength > 0),
        keyboardType = maxLines == 1 ? keyboardType : ITextInputType.multiline,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ITextFieldState();
}

class _ITextFieldState extends State<ITextField> {
  String _inputText = "";
  bool _hasdeleteIcon = false;
  bool _isNumber = false;
  bool _isPassword = false;

  ///输入类型
  TextInputType _getTextInputType() {
    switch (widget.keyboardType) {
      case ITextInputType.text:
        return TextInputType.text;
      case ITextInputType.multiline:
        return TextInputType.multiline;
      case ITextInputType.number:
        _isNumber = true;
        return TextInputType.number;
      case ITextInputType.phone:
        _isNumber = true;
        return TextInputType.phone;
      case ITextInputType.numberAndDecimal:
        _isNumber = false;
        return TextInputType.numberWithOptions(decimal: true,signed: true);
      case ITextInputType.datetime:
        return TextInputType.datetime;
      case ITextInputType.emailAddress:
        return TextInputType.emailAddress;
      case ITextInputType.url:
        return TextInputType.url;
      case ITextInputType.password:
        _isPassword = true;
        return TextInputType.text;
      case ITextInputType.passwordAndNumber:
        _isPassword = true;
        _isNumber = true;
        return TextInputType.number;
    }
  }

  ///输入范围
  List<TextInputFormatter> _getTextInputFormatter() {
    return _isNumber
        ? <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ]
        : widget.keyboardType==ITextInputType.numberAndDecimal?
    <TextInputFormatter>[
      UsNumberTextInputFormatter(),
    ]:null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = new TextEditingController.fromValue(
        TextEditingValue(
            text: _inputText,
            selection: new TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: _inputText.length))));
    TextField textField = widget.needDelete? TextField(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      controller: _controller,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintStyle: widget.hintStyle,
        contentPadding: widget.contentPadding == null
            ? EdgeInsets.all(12)
            : widget.contentPadding,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        border: widget.inputBorder != null
            ? widget.inputBorder
            : UnderlineInputBorder(),
        fillColor: Colors.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.needDelete
            ? _hasdeleteIcon
                ? new Container(
                    width: 20.0,
                    height: 20.0,
                    child: new IconButton(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0.0),
                      iconSize: 18.0,
                      icon: widget.deleteIcon != null
                          ? widget.deleteIcon
                          : Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          _inputText = "";
                          _hasdeleteIcon = (_inputText.isNotEmpty);
                          widget.fieldCallBack(_inputText);
                        });
                      },
                    ),
                  )
                : new Text("")
            : Text(""),
      ),
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasdeleteIcon = (_inputText.isNotEmpty);
          widget.fieldCallBack(_inputText);
        });
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword,
    ):TextField(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      controller: _controller,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintStyle: widget.hintStyle,
        contentPadding: widget.contentPadding == null
            ? EdgeInsets.all(12)
            : widget.contentPadding,
        counterStyle: TextStyle(color: Colors.white),
        hintText: widget.hintText,
        border: widget.inputBorder != null
            ? widget.inputBorder
            : UnderlineInputBorder(),
        fillColor: Colors.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
      ),
      onChanged: (str) {
        setState(() {
          _inputText = str;
          _hasdeleteIcon = (_inputText.isNotEmpty);
          widget.fieldCallBack(_inputText);
        });
      },
      keyboardType: _getTextInputType(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      inputFormatters: _getTextInputFormatter(),
      style: widget.textStyle,
      obscureText: _isPassword,
    );
    return textField;
  }

  @override
  void initState() {
    super.initState();
    _inputText = widget.inputText;
    if (_inputText.length > 0) {
      _hasdeleteIcon = true;
    } else {
      _hasdeleteIcon = false;
    }
  }
}
