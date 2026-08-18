import 'dart:async';

import 'package:flutter/cupertino.dart';

typedef OnEventListener = void Function(Map<String, dynamic>? event);

/// 防抖时间记录：以返回的target闭包自身为key（identity语义），
/// 不同按钮/不同build实例互不影响，且Expando不会阻止GC
final Expando<num> _lastClickTime = Expando('lastClickTime');

void Function() onClick(Function func,
    [num delyTime = 1000,
    Map<String, dynamic>? event]) {

  // late声明以允许闭包内自引用target作为防抖key
  late void Function() target;
  target = () {
    var time = DateTime.now().millisecondsSinceEpoch;
    var lastTime = _lastClickTime[target];

    // 首次点击（无记录）不拦截；delyTime内的连点拦截
    if (lastTime != null && time - lastTime < delyTime) {
      return;
    }
    _lastClickTime[target] = time;

    func.call();
    if (ListenerGlobal.listener != null) {
      ListenerGlobal.listener!(event);
    }
  };

  return target;
}

class ListenerGlobal {
  static OnEventListener? listener;

  static void addGlobalListener(OnEventListener listener) {
    ListenerGlobal.listener = listener;
  }
}
