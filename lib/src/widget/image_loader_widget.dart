import 'dart:io';
import 'package:base_flutter/base_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

typedef ImageCookieInit = String Function();
class ImageLoad extends StatelessWidget {

  final String path;
  static ImageCookieInit? cookieInit;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final String? errorImage;
  final String? placeholder;
  final double? width;
  final double? height;
  final Color? color;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final bool isAntiAlias;
  final double scale;
  final bool isAsset;
  final String? package;
  Map<String, String>? headers;

  ImageLoad(
    this.path, {
    this.frameBuilder,
    this.loadingBuilder,
    this.errorImage,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.scale = 1.0,
        this.placeholder,
        this.isAsset = false,
        this.package,
        this.headers
  });

  @override
  Widget build(BuildContext context) {
    if(cookieInit!=null){
      String cookie = cookieInit!();
      if(headers==null){
        headers = {"Cookie":cookie};
      }else{
        headers!['Cookie'] = cookie;
      }
    }
    return path.startsWith("http") || path.startsWith("https")
        ? Image(
            image: CachedNetworkImageProvider(path, scale: scale,headers: headers),
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder!=null?loadingBuilder:placeholder.isNullOrEmpty()?null:(context,child,process){
              if(process==null){
                return child;
              }else{
                return Image.asset(placeholder??"",width: width,height: height,);
              }
            },
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              print("error========>${error.toString()}");
              return errorImage.isNullOrEmpty()
                  ? Container(
                      width: width,
                      height: height,
                    )
                  : Image.asset(
                      errorImage!,
                      width: width,
                      height: height,
                    );
            },
            semanticLabel: semanticLabel,
            excludeFromSemantics: excludeFromSemantics,
            width: width,
            height: height,
            color: color,
            colorBlendMode: colorBlendMode,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            centerSlice: centerSlice,
            matchTextDirection: matchTextDirection,
            gaplessPlayback: gaplessPlayback,
            filterQuality: filterQuality,
            isAntiAlias: isAntiAlias,
          )
        : isAsset?Image.asset(path,scale: scale, frameBuilder: frameBuilder,
        package: package,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return errorImage.isNullOrEmpty()
              ? Container(
            width: width,
            height: height,
          )
              : Image.asset(
            errorImage!,
            width: width,
            height: height,
          );
        },
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias):Image.file(new File(path), scale: scale, frameBuilder: frameBuilder,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return errorImage.isNullOrEmpty()
              ? Container(
            width: width,
            height: height,
          )
              : Image.asset(
            errorImage!,
            width: width,
            height: height,
          );
        },
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias);
  }
}

String formatImage(String name, {String format = ".png",String parentPath = "images"}) {
  return "${parentPath}/$name$format";
}
