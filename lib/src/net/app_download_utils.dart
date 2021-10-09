// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'app_download_dialog.dart';
//
// class AppDownloadUtils{
//
//   void showDownloadDialog(BuildContext context,String url,String path,onFinish,onError){
//     showDialog(context: context, builder: (context){
//       return WillPopScope(
//         child: AlertDialog(
//             contentPadding: EdgeInsets.all(0),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             content: AppDownloadDialog(url,path,onFinish,onError)
//         ),
//         onWillPop:() async{
//           return Future.value(false);
//         },
//       );
//     },barrierDismissible: false);
//   }
// }