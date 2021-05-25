import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenHelper{

  static bool _needFitScreen = true;

  static void openFit(bool open){
    _needFitScreen = open;
  }

  static void initHelper(BoxConstraints constraints,{Orientation orientation = Orientation.portrait,double width = 360,double height = 690,bool allowFontScaling = false}){
    if(_needFitScreen){
    ScreenUtil.init(constraints,orientation: orientation,designSize: Size(width, height));
    }
  }

  static double screenWidth(){
    return ScreenUtil().screenWidth;
  }


  static double screenHeight(){
    return ScreenUtil().screenHeight;
  }

  static ScreenUtil getScreenUtils(){
    return ScreenHelper.getScreenUtils();
  }
}




