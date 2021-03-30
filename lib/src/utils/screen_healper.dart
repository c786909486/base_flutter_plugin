import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenHelper{

  static bool _needFitScreen = false;

  static void openFit(bool open){
    _needFitScreen = open;
  }

  static void initHelper(BoxConstraints constraints,Orientation orientation,double width,double height,{bool allowFontScaling = true}){
    if(_needFitScreen){
      ScreenUtil.init(constraints,orientation: orientation,designSize: Size(width, height),allowFontScaling: allowFontScaling);
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




