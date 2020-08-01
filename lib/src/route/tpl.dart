import '../../build_route.dart';

const String routerTpl = """
import 'package:base_flutter/build_route.dart';
{{#imports}}
import '{{{path}}}';
{{/imports}}

class RouterInternalImpl extends RouterInternal {
  RouterInternalImpl();
  final Map<String, dynamic> routeMap = {{{routeMap}}};

  @override
  RouteResult router(String url,{Map<String,dynamic> params}) {
    try {
      String path =url;
      if(path == null) {
        return RouteResult(state:RouterResultState.NOT_FOUND);
      }
      
      final Type pageClass = routeMap[path];
      if(pageClass == null) {
        return RouteResult(state: RouterResultState.NOT_FOUND);
      }
      final dynamic classInstance = createInstance(pageClass, params);
      return RouteResult(widget: classInstance, state:RouterResultState.FOUND);
    }
    catch(e) {
      return RouteResult(state:RouterResultState.NOT_FOUND);
    }
  }

  dynamic createInstance(Type clazz, Map<String,dynamic> params) {
    {{{classInstance}}}
  }
}
""";

