import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';

class ToastUtils{

  static void shotToast(String msg,{required BuildContext context,Alignment alignment = Alignment.center,int duration = 1800}){
    // showToast(msg,context: context,alignment: alignment,position: StyledToastPosition.center,animDuration: Duration(seconds: 0));
    FToast.toast(context,msg: msg,duration: duration ,msgStyle: TextStyle(color: Colors.white),);
  }
}