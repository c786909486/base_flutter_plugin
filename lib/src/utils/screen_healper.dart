// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ScreenHelper{
//
//   static bool _needFitScreen = true;
//
//   static void openFit(bool open){
//     _needFitScreen = open;
//   }
//
//   static void initHelper(BoxConstraints constraints,{BuildContext? context,Orientation orientation = Orientation.portrait,double width = 360,double height = 690,bool allowFontScaling = false}){
//     if(_needFitScreen){
//       ScreenUtil.init(constraints,orientation: orientation,context: context,designSize: Size(width, height));
//     }
//   }
//
//   static double screenWidth(){
//     return ScreenUtil().screenWidth;
//   }
//
//
//   static double screenHeight(){
//     return ScreenUtil().screenHeight;
//   }
//
//   static ScreenUtil getScreenUtils(){
//     return ScreenHelper.getScreenUtils();
//   }
//
//
//   static double width(BuildContext context){
//
//     return MediaQuery.of(context).size.width;
//   }
//
//   static double height(BuildContext context){
//
//     return MediaQuery.of(context).size.height;
//   }
// }
//
//
//
//
