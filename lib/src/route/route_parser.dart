//import 'package:build/build.dart';
//import 'package:source_gen/source_gen.dart';
//
//class RouteParser {
//  Map<String, dynamic> routeMap = {};
//  List<String> importList = [];
//
//  void parseRoute(ClassElement element, ConstantReader annotation, BuildStep buildStep) {
//    print('start parseRoute for ${element.displayName}');
//    String url = annotation.peek('url').stringValue;
//    try {
//
//
//      if(url == null) {
//        print('parse route error: bad path for $url');
//        return;
//      }
//      if(routeMap[url] != null) {
//        print('parse route error: already exist for $url');
//        return;
//      }
//      routeMap[url] = element.displayName;
//      if (buildStep.inputId.path.contains('lib/')) {
//        print(buildStep.inputId.path);
//        importList.add(
//            "package:${buildStep.inputId.package}/${buildStep.inputId.path.replaceFirst('lib/', '')}");
//      } else {
//        importList.add("${buildStep.inputId.path}");
//      }
//    } catch (e) {
//      print('parse route error $e');
//    }
//  }
//}