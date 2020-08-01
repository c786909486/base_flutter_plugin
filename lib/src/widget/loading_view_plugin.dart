import 'package:base_flutter/src/res/drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnRetryEvent();

class LoadingViewPlugin {
  static TextStyle _textStyle = TextStyle(fontSize: 18, color: Colors.black);

  static TextStyle _retryStyle = TextStyle(fontSize: 14, color: Colors.grey);

  BuildContext _context;

  LoadingViewPlugin(this._context);

  ///全局加载布局
  static Widget _globeLoadingWidget;

  ///全局错误布局
  static Widget _globeErrorWidget;

  ///全局空白布局
  static Widget _globeEmptyWidget;

  ///页面中替换加载布局
  Widget _loadingWidget;

  ///页面中替换错误布局
  Widget _errorWidget;

  ///页面中替换空白布局
  Widget _emptyWidget;

  void initWidget(
      {Widget loadingWidget, Widget errorWidget, Widget emptyWidget}) {
    _loadingWidget = loadingWidget;
    _errorWidget = errorWidget;
    _emptyWidget = emptyWidget;
  }

  static void initGlobeLoading(
      {Widget loadingWidget, Widget errorWidget, Widget emptyWidget}) {
    _globeLoadingWidget = loadingWidget;
    _globeEmptyWidget = emptyWidget;
    _globeErrorWidget = errorWidget;
  }

  Widget getLoadingWidget() {
    if (_loadingWidget != null) {
      return _loadingWidget;
    } else if (_globeLoadingWidget != null) {
      return _globeLoadingWidget;
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget getErrorWidget(String error, OnRetryEvent event) {
    if (_errorWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _errorWidget,
        onTap: () {
          event();
        },
      );
    } else if (_globeErrorWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _globeErrorWidget,
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

  Widget getEmptyWidget(OnRetryEvent event) {
    if (_emptyWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _emptyWidget,
        onTap: () {
          event();
        },
      );
    } else if (_globeEmptyWidget != null) {
      return InkWell(
        highlightColor: Colors.transparent,
        radius: 0,
        child: _globeEmptyWidget,
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
}
