import 'package:flutter/cupertino.dart';

mixin PageLifeCircleMixin <T extends StatefulWidget> on State<T> {
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    StateLifecycleManager.instance.addLifecycle(this);
  }

  @mustCallSuper
  @override
  void dispose() {
    StateLifecycleManager.instance.removeLifecycle(this);
    super.dispose();
  }

  ///页面回到正在展示状态
  @protected
  void onResume();

  ///页面处于非正在展示中
  @protected
  void onPause();
}

class StateLifecycleManager {
  factory StateLifecycleManager() {
    return _getInstance();
  }

  static final StateLifecycleManager _instance = StateLifecycleManager._();

  static StateLifecycleManager get instance => _instance;

  static StateLifecycleManager _getInstance() {
    return _instance;
  }
  final Map<String,PageLifeCircleMixin> _map = {};

  StateLifecycleManager._();

  ///添加
  addLifecycle(PageLifeCircleMixin lifecycleMixin) {
    if (!_map.containsValue(lifecycleMixin)) {
      _map[lifecycleMixin.widget.runtimeType.toString()] = lifecycleMixin;
    }
  }

  ///移除
  removeLifecycle(PageLifeCircleMixin lifecycleMixin) {
    if (_map.containsValue(lifecycleMixin)) {
      _map.remove(lifecycleMixin.widget.runtimeType.toString());
    }
  }

  onResume(String routerName) {
    if(_map.containsKey(routerName)){
      _map[routerName]?.onResume();
    }
  }
  onPause(String routerName) {
    if(_map.containsKey(routerName)){
      _map[routerName]?.onPause();
    }
  }
}