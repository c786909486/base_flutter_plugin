import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastUtils{

  static void shotToast(String msg,{BuildContext? context,Alignment alignment = Alignment.center}){
    showToast(msg,context: context,alignment: alignment,position: StyledToastPosition.center,animDuration: Duration(seconds: 0));
  }
}