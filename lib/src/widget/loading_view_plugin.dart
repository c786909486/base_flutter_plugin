import 'package:base_flutter/src/res/drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnRetryEvent();
typedef LoadingViewBuilder = Widget Function(BuildContext context,String msg);

class LoadingViewPlugin {
  static TextStyle _textStyle = TextStyle(fontSize: 18, color: Colors.black);

  static TextStyle _retryStyle = TextStyle(fontSize: 14, color: Colors.grey);

  BuildContext _context;

  LoadingViewPlugin(this._context);

  ///全局加载布局
  static  LoadingViewBuilder? _globeLoadingWidget;

  ///全局错误布局
  static  LoadingViewBuilder? _globeErrorWidget;

  ///全局空白布局
  static  LoadingViewBuilder? _globeEmptyWidget;

  ///页面中替换加载布局
  LoadingViewBuilder? _loadingWidget;

  ///页面中替换错误布局
  LoadingViewBuilder? _errorWidget;

  ///页面中替换空白布局
  LoadingViewBuilder? _emptyWidget;

  void initWidget(
      {LoadingViewBuilder? loadingWidget, LoadingViewBuilder? errorWidget, LoadingViewBuilder? emptyWidget}) {
    _loadingWidget = loadingWidget;
    _errorWidget = errorWidget;
    _emptyWidget = emptyWidget;
  }

  static void initGlobeLoading(
      {LoadingViewBuilder? loadingWidget, LoadingViewBuilder? errorWidget, LoadingViewBuilder? emptyWidget}) {
    _globeLoadingWidget = loadingWidget;
    _globeEmptyWidget = emptyWidget;
    _globeErrorWidget = errorWidget;
  }

  Widget getLoadingWidget(BuildContext context) {
    if (_loadingWidget != null) {
      return _loadingWidget!(context,"");
    } else if (_globeLoadingWidget != null) {
      return _globeLoadingWidget!(context,"");
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget getErrorWidget(BuildContext context,String error, OnRetryEvent event) {
    if (_errorWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _errorWidget!(context,error),
        onTap: () {
          event();
        },
      );
    } else if (_globeErrorWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _globeErrorWidget!(context,error),
        onTap: () {
          event();
        },
      );
    } else {
      return Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          radius: 0,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Drawable.image_error,
                  package: "base_flutter",
                  width: 80,
                ),
                Container(
                  height: 20,
                ),
                Text(error, style: _textStyle),
                Container(
                  height: 10,
                ),
                Text(
                  "点击重试",
                  style: _retryStyle,
                ),
              ],
            ),
          ),
          onTap: () {
            event();
          },
        ),
      );
    }
  }

  Widget getEmptyWidget(BuildContext context,OnRetryEvent event) {
    if (_emptyWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _emptyWidget!(context,""),
        onTap: () {
          event();
        },
      );
    } else if (_globeEmptyWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _globeEmptyWidget!(context,""),
        onTap: () {
          event();
        },
      );
    } else {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Drawable.image_empty,
                package: "base_flutter",
                width: 80,
                color: Colors.grey,
              ),
              Container(
                height: 20,
              ),
              Text(
                "暂无数据",
                style: _textStyle,
              ),
              Container(
                height: 10,
              ),
              Text(
                "点击重试",
                style: _retryStyle,
              ),
            ],
          ),
        ),
        onTap: () {
          event();
        },
      );
    }
  }

  void release(){
    _loadingWidget = null;
    _emptyWidget = null;
    _errorWidget = null;
  }

  static void clearGlobal(){
    _globeLoadingWidget = null;
    _globeEmptyWidget= null;
    _globeErrorWidget = null;
  }
}
