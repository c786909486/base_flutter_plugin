//import 'package:analyzer/dart/element/element.dart';
//import 'package:base_flutter/base_flutter.dart';
//import 'package:base_flutter/src/route/route_parser.dart';
//import 'package:base_flutter/src/route/router_writer.dart';
//import 'package:build/build.dart';
//import 'package:source_gen/source_gen.dart';
//
//import 'build_route.dart';
//
//
/////解析被EasyRoute注解标识的页面
//class RouteParseGenerator extends GeneratorForAnnotation<BuildRoute> {
//  static RouteParser routeParser = RouteParser();
//
//  @override
//  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
//    routeParser.parseRoute(element, annotation, buildStep);
//    return null;
//  }
//}
//
/////生成Router逻辑
//class RouterGenerator extends GeneratorForAnnotation<BuildRoute> {
//  RouteParser routeParser() {
//    return RouteParseGenerator.routeParser;
//  }
//
//  @override
//  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
//    return RouterWriter(routeParser()).write();
//  }
//}