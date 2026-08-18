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

  ///按页面名索引的实例列表，支持同名页面多实例共存（如同时打开两个同名页面）
  final Map<String, List<PageLifeCircleMixin>> _map = {};

  ///已注册实例集合（identity语义），O(1)判断是否已注册
  final Set<PageLifeCircleMixin> _registered = {};

  StateLifecycleManager._();

  ///添加
  addLifecycle(PageLifeCircleMixin lifecycleMixin) {
    if (_registered.add(lifecycleMixin)) {
      final key = lifecycleMixin.widget.runtimeType.toString();
      _map.putIfAbsent(key, () => []).add(lifecycleMixin);
    }
  }

  ///移除
  removeLifecycle(PageLifeCircleMixin lifecycleMixin) {
    if (_registered.remove(lifecycleMixin)) {
      final key = lifecycleMixin.widget.runtimeType.toString();
      _map[key]?.remove(lifecycleMixin);
      if (_map[key]?.isEmpty ?? true) {
        _map.remove(key);
      }
    }
  }

  onResume(String routerName) {
    final list = _map[routerName];
    if (list != null && list.isNotEmpty) {
      // 通知最近注册（最上层）的同名页面
      list.last.onResume();
    }
  }
  onPause(String routerName) {
    final list = _map[routerName];
    if (list != null && list.isNotEmpty) {
      list.last.onPause();
    }
  }
}