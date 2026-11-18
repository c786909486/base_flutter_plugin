import 'package:ftoast/ftoast.dart';
import 'package:material_ui/material_ui.dart';

class ToastUtils{

  static void shotToast(String msg,{required BuildContext context,Alignment alignment = Alignment.center,int duration = 1800}){
    // showToast(msg,context: context,alignment: alignment,position: StyledToastPosition.center,animDuration: Duration(seconds: 0));
    FToast.toast(context,msg: msg,duration: duration ,msgStyle: TextStyle(color: Colors.white),);
  }
}