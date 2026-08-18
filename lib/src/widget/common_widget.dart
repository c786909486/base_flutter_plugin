import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/cupertino.dart';
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
      Brightness? brightness,
      IconThemeData? iconTheme,
      Color backgroundColor = Colors.white,
      PreferredSizeWidget? bottom,
      bool automaticallyImplyLeading = true,
      Key? key}) {
  return AppBar(
    backgroundColor: backgroundColor,
    centerTitle: centerTitle,
    elevation: elevation,
    automaticallyImplyLeading: automaticallyImplyLeading,
    iconTheme: iconTheme ?? IconThemeData(color: Colors.black),
    key: key,
    title: Text(
      title,
      style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 17.0,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontFamily: fontFamily),
    ),
    actions: actions,
    leading: leading,
    bottom: bottom,
  );
}

Widget createInput(String text, ITextFieldCallBack fieldCallBack,
    {String hintText = "请输入",
      ITextInputType keyboardType = ITextInputType.text,
      int weight = 3}) {
  return ITextField(
    inputText: text,
    hintText: "请输入",
    textStyle: TextStyle(color: Colors.black, fontSize: 15.0),
    keyboardType: keyboardType,
    textInputAction: TextInputAction.next,
    hintStyle: TextStyle(fontSize: 15.0, color: Color(0xFF646566)),
    fieldCallBack: fieldCallBack,
    inputBorder: OutlineInputBorder(borderSide: BorderSide.none),
    textAlign: TextAlign.right,
    needDelete: false,
    autofocus: false,
    contentPadding: EdgeInsets.all(0),
  ).setWeight(weight);
}

Widget createNormalInput(String text,
    ITextFieldCallBack fieldCallBack, {
      String hintText = "请输入",
      TextInputType keyboardType = TextInputType.text,
      TextAlign? textAlign = TextAlign.right,
      int weight = 3,
    }) {
  return _NormalInputField(
    text: text,
    fieldCallBack: fieldCallBack,
    hintText: hintText,
    keyboardType: keyboardType,
    textAlign: textAlign,
    weight: weight,
  );
}

///管理 TextEditingController 生命周期，避免每次build新建controller导致输入状态丢失/内存泄漏
class _NormalInputField extends StatefulWidget {
  final String text;
  final ITextFieldCallBack fieldCallBack;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final int weight;

  const _NormalInputField({
    Key? key,
    required this.text,
    required this.fieldCallBack,
    this.hintText = "请输入",
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.right,
    this.weight = 3,
  }) : super(key: key);

  @override
  State<_NormalInputField> createState() => _NormalInputFieldState();
}

class _NormalInputFieldState extends State<_NormalInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(_valueOf(widget.text));
  }

  @override
  void didUpdateWidget(_NormalInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部text变化时同步，但避免覆盖用户正在输入的内容
    if (oldWidget.text != widget.text && widget.text != _controller.text) {
      _controller.value = _valueOf(widget.text);
    }
  }

  TextEditingValue _valueOf(String text) {
    return TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.black, fontSize: 15.0),
      keyboardType: widget.keyboardType,
      textInputAction: TextInputAction.next,
      onChanged: widget.fieldCallBack,
      textAlign: widget.textAlign ?? TextAlign.right,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: widget.hintText,
        contentPadding: EdgeInsets.all(0),
        hintStyle: TextStyle(fontSize: 15.0, color: Color(0xFF646566)),
      ),
    );
    return widget.weight == 0 ? field : field.setWeight(widget.weight);
  }
}

class CheckWithText extends StatelessWidget {
  bool defaultSelected;
  String title;
  Function(bool value) onChanged;
  MainAxisAlignment mainAxisAlignment;
  Color? checkedColor;
  Color? fillColor;
  bool enable;
  TextStyle? textStyle;

  CheckWithText({this.defaultSelected = false,
    required this.title,
    required this.onChanged,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.checkedColor,
    this.fillColor,this.enable = true,this.textStyle});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            fillColor: WidgetStateProperty.all(fillColor),
            checkColor: checkedColor,
            value: defaultSelected,
            onChanged: (value) {
              if(enable){
                setState(() {
                  defaultSelected = value ?? false;
                });
                onChanged(defaultSelected);
              }
            },
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          ),
          Text(title,style: textStyle??TextStyle(fontSize: 16,color: Colors.blue),).addToContainer(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width-100)),
        ],
      ).onTap(() {
        if(enable){
          setState(() {
            defaultSelected = !defaultSelected;
          });
          onChanged(defaultSelected);
        }
      });
    });
  }
}

class RadioWithText<T> extends StatelessWidget {
  T value;
  T? groupValue;
  ValueChanged<T?>? onChanged;
  Widget text;
  Color? activeColor;

  RadioWithText({required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: activeColor,visualDensity: VisualDensity(horizontal: -4, vertical: -4),),
        text
      ],
    ).onTap(() {
      onChanged!(value);
    });
  }
}
