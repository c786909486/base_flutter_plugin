import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenHelper{

  static bool _needFitScreen = false;

  static void openFit(bool open){
    _needFitScreen = open;
  }

  static void initHelper(BuildContext context,double width,double height,{bool allowFontScaling = true}){
    if(_needFitScreen){
      ScreenUtil.instance = ScreenUtil(width: width,height: height,allowFontScaling: allowFontScaling)..init(context);
    }
  }

  static double screenWidth(){
    return ScreenUtil.getInstance().width;
  }


  static double screenHeight(){
    return ScreenUtil.getInstance().height;
  }

  static ScreenUtil getScreenUtils(){
    return ScreenHelper.getScreenUtils();
  }
}




