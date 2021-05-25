
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastUtils{

  static void shotToast(String msg,{BuildContext context,Alignment alignment}){
    showToast(msg,context: context,alignment: alignment);
  }
}