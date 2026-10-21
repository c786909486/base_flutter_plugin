import 'package:base_flutter/base_flutter.dart';

/// 网络请求示例：把某一业务模块的接口封装在 mixin 里，ViewModel 直接混入使用。
///
/// - 统一走 HttpGo（dio_net_work），base_flutter 已导出 dio 的 Options / Headers / CancelToken。
/// - baseUrl 在 main.dart 的 initNet() 里统一设置。
/// - 统一校验业务码：code == '0' 视为成功，否则抛错
///   （列表页会自动显示错误态，普通页面 catch 后提示）。
mixin RequestNetModel {
  /// GET 分页列表。
  ///
  /// 相对路径会拼到 main.dart 里设置的 HttpGo baseUrl 上。
  Future<List<dynamic>> requestList({int page = 1, int rows = 20}) async {
    final data = await HttpGo.instance.getData('/api/list', data: {
      'page': page,
      'rows': rows,
    });
    _checkCode(data);
    final list = data['data'];
    return list is List ? list : <dynamic>[];
  }

  /// POST JSON 提交。
  Future<Map<String, dynamic>> requestSubmit({dynamic id, dynamic info}) async {
    final data = await HttpGo.instance.postData(
      '/api/submit',
      data: {'id': id, 'info': info},
      options: Options(contentType: Headers.jsonContentType),
    );
    _checkCode(data);
    final result = data['data'];
    return result is Map<String, dynamic> ? result : <String, dynamic>{};
  }

  /// POST 表单提交（后端按 form-urlencoded 接收参数时使用）。
  Future<Map<dynamic, dynamic>> requestLogin({
    required String username,
    required String password,
  }) async {
    final data = await HttpGo.instance.postData(
      '/api/login',
      data: {'username': username, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    _checkCode(data);
    return data ;
  }

  /// 业务码约定：{"code": "0", "msg": "ok", "data": ...}
  ///
  /// 非成功时抛出后端 msg，交给框架统一处理：
  /// - 列表页：BaseListViewModel 捕获并自动显示错误态；
  /// - 普通页：catch 后 showErrorState(e.toNetError()) 或 showToast(msg)。
  void _checkCode(Map data) {
    if ('${data['code']}' != '0') {
      throw '${data['msg'] ?? '请求失败'}';
    }
  }
}
