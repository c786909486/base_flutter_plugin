import 'dart:developer' as developer;
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 入口页：用于跳转到第一个 BaseMvvmState 生命周期演示页
// ---------------------------------------------------------------------------

class LifecycleDemoEntryPage extends StatelessWidget {
  const LifecycleDemoEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('onResume / onPause 演示')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Go().push(_LifecyclePage(label: 'Page-A', color: Colors.blue));
          },
          child: const Text('打开 Page-A（BaseMvvmState）'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 可复用的 BaseMvvmState 演示页
// ---------------------------------------------------------------------------

class _LifecyclePage extends BaseStatefulMvvmWidget {
  final String label;
  final Color color;

  _LifecyclePage({required this.label, required this.color});

  @override
  State<StatefulWidget> createState() => _LifecyclePageState();
}

class _LifecyclePageState
    extends BaseMvvmState<_LifecycleViewModel, _LifecyclePage> {
  int _resumeCount = 0;
  int _pauseCount = 0;

  // ==================== 生命周期钩子 ====================

  @override
  void onResume() {
    super.onResume(); // 必须调用，更新 isPageVisible
    _resumeCount++;
    _log('✅ onResume  (resumeCount=$_resumeCount, isPageVisible=$isPageVisible)');
    setState(() {

    });
  }

  @override
  void onPause() {
    super.onPause(); // 必须调用，更新 isPageVisible
    _pauseCount++;
    _log('⏸ onPause   (pauseCount=$_pauseCount, isPageVisible=$isPageVisible)');
  }

  // ==================== BaseMvvmState 抽象方法 ====================

  @override
  _LifecycleViewModel createViewModel() => _LifecycleViewModel(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.label} 生命周期演示'),
        backgroundColor: widget.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- 状态卡片 ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '页面: ${widget.label}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _statusRow('isPageVisible', isPageVisible),
                    const SizedBox(height: 4),
                    _statusRow('onResume 次数', _resumeCount),
                    const SizedBox(height: 4),
                    _statusRow('onPause  次数', _pauseCount),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ---- 操作按钮 ----
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // 跳转到另一个同类型页面，当前页面应该触发 onPause
                Go().push(_LifecyclePage(
                  label: '${widget.label}-sub',
                  color: widget.color == Colors.blue
                      ? Colors.indigo
                      : Colors.teal,
                ));
              },
              child: Text('跳转到 ${widget.label}-sub（当前页 onPause）'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // 返回上一页，上一页应该触发 onResume
                finish();
              },
              child: const Text('返回上一页（上一页 onResume）'),
            ),
            const SizedBox(height: 24),

            // ---- 日志区域 ----
            const Text('生命周期日志:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: _logNotifier,
                  builder: (_, logs, __) => ListView.builder(
                    reverse: true,
                    itemCount: logs.length,
                    itemBuilder: (_, i) => Text(
                      logs[logs.length - 1 - i],
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? buildLoadingContentView() => null;

  @override
  void onRetryClick() {}

  // ==================== 工具方法 ====================

  static Widget _statusRow(String label, dynamic value) {
    final color = value == true
        ? Colors.green
        : value == false
            ? Colors.red
            : Colors.black87;
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Text(
          '$value',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  static final _logNotifier = ValueNotifier<List<String>>([]);

  void _log(String msg) {
    final entry =
        '[${DateTime.now().toString().substring(11, 23)}] ${widget.label}: $msg';
    developer.log(entry, name: 'LifecycleDemo');
    debugPrint('🔍 $entry');

    final list = List<String>.from(_logNotifier.value);
    list.add(entry);
    // 保留最近 50 条
    if (list.length > 50) list.removeRange(0, list.length - 50);
    _logNotifier.value = list;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _log('🚀 initState 完成 (isPageVisible=$isPageVisible)');
    });
  }
}

// ==================== ViewModel ====================

class _LifecycleViewModel extends BaseViewModel {
  _LifecycleViewModel(BuildContext context) : super(context);
}
