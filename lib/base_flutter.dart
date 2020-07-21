library base_flutter;

import 'package:flutter/cupertino.dart';
export 'package:base_flutter/src/base_mvp/IBasePresenter.dart';
export 'package:base_flutter/src/base_mvp/IBaseView.dart';
export 'package:base_flutter/src/base_mvp/BaseModel.dart';
export 'package:base_flutter/src/base_mvp/BaseWidget.dart';
export 'package:base_flutter/src/base_mvp/BasePresenter.dart';
export 'package:base_flutter/src/utils/share_preference_utils.dart';
export 'package:base_flutter/src/net/app_download_utils.dart';
export 'package:base_flutter/src/net/http_utils.dart';
export 'package:base_flutter/src/utils/base_route_utils.dart';
export 'package:base_flutter/src/utils/utils.dart';
export 'package:base_flutter/src/utils/service_locator.dart';
export 'package:base_flutter/src/utils/toast_utils.dart';
export "package:base_flutter/src/base_mvvm/base_model_mvvm.dart";
export "package:base_flutter/src/base_mvvm/base_stateful_widget_mvvm.dart";
export "package:base_flutter/src/base_mvvm/base_view_model_mvvm.dart";
export "package:base_flutter/src/base_mvvm/base_view_mvvm.dart";

class BaseFlutter{
  static BuildContext application;

  static void init(BuildContext context){
    application = context;
  }
}





