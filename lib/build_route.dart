/////定义页面路由注解
//class BuildRoute{
//  final String url;
//
//  const BuildRoute({this.url});
//}
//
/////定义路由解析器注解
//class BuildRouter{
//  const BuildRouter();
//}
//
/////路由结果状态
/////[FOUND]: 找到
/////[NOT_FOUND]: 未找到
//enum RouterResultState {
//  FOUND,
//  NOT_FOUND
//}
//
/////路由结果
//class RouteResult {
//  dynamic widget;
//  RouterResultState state;
//
//  RouteResult({this.widget, this.state});
//}
//
/////路由内部接口
//abstract class RouterInternal {
//  RouteResult router(String url,{Map<String,dynamic> params});
//}
//
//const Object buildRouter = const BuildRouter();
//
