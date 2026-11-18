// App 入口模板：接入 base_flutter 基础框架必须配置导航 key 与 observer。
//
// 缺少 navigatorKey：Go().push(...) 会抛空指针。
// 缺少 StateNavigatorObserver：页面的 onResume/onPause/isPageVisible 不会更新。
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetPlatform.init(); // web 跨域网络适配（非 web 空操作），可选
  await SpUtil.getInstance(); // 本地存储初始化，可选
  DevConfig.instance.init(); // 开发者模式/抓包代理配置，可选
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // 必须：Go() 跳转依赖全局 navigatorKey
      navigatorKey: NavigateService.getInstance().key,
      // 必须：页面可见性/生命周期回调依赖该 observer
      navigatorObservers: [StateNavigatorObserver()],
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // TODO: 替换为工程自己的首页，例如：
      // home: const HomePage(),
      home: const _BootstrapHomePage(),
    );
  }
}

// 占位首页，复制模板后请删除并换成业务首页。
class _BootstrapHomePage extends StatelessWidget {
  const _BootstrapHomePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}
