import 'dart:async';

typedef OnEventListener = void Function(Map<String, dynamic>? event);

void Function() onClick(Function func,
    [num delyTime = 1000,
    Map<String, dynamic>? event]) {
  num lastClickTime = 0;

  bool Function() isFastClick = () {
    var time = DateTime.now().millisecondsSinceEpoch;
    var timed = time - lastClickTime;


    if (0 < timed && timed < delyTime) {
      return true;
    } else {
      lastClickTime = time;
      return false;
    }
  };

  void Function() target = () {
    if(!isFastClick()){
      func.call();
      if (ListenerGlobal.listener != null) {
        ListenerGlobal.listener!(event);
      }
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
