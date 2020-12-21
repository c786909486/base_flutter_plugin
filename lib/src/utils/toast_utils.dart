import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils{

  static void shotToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
  }
}