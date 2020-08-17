// 只允许输入小数
import 'package:flutter/services.dart';

class UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.01;
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" && value != defaultDouble.toString() && strToFloat(value, defaultDouble) == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }else if(value.contains(".")&&value.substring(value.lastIndexOf(".")+1).length>2){
      value = value.substring(0,value.lastIndexOf(".")+3);
      selectionIndex =newValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}