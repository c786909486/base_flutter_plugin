import 'dart:io';
import 'package:base_flutter/base_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

typedef ImageCookieInit = String Function();
typedef ImageHeader = Map<String, String>? Function();

class ImageLoad extends StatefulWidget {
  final String path;
  static ImageCookieInit? cookieInit;
  static ImageHeader? headerInit;
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

  ///限制解码尺寸（像素），不传时按 [width]/[height] 与设备像素比自动推导
  final int? cacheWidth;
  final int? cacheHeight;

  ImageLoad(this.path,
      {this.frameBuilder,
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
      this.headers,
      this.cacheWidth,
      this.cacheHeight});

  @override
  State<ImageLoad> createState() => _ImageLoadState();
}

class _ImageLoadState extends State<ImageLoad> {
  ///缓存的headers，避免每次build生成新Map导致缓存key变化、图片反复下载
  Map<String, String>? _headers;

  @override
  void initState() {
    super.initState();
    _headers = _resolveHeaders();
  }

  @override
  void didUpdateWidget(ImageLoad oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部传入的headers变化时才重新合并全局header
    if (oldWidget.headers != widget.headers) {
      _headers = _resolveHeaders();
    }
  }

  Map<String, String>? _resolveHeaders() {
    Map<String, String>? headers = widget.headers;
    if (ImageLoad.headerInit != null) {
      var headerMap = ImageLoad.headerInit!();
      if (headers == null) {
        headers = headerMap;
      } else {
        headers = {...headers, ...?headerMap};
      }
    }
    if (ImageLoad.cookieInit != null) {
      String cookie = ImageLoad.cookieInit!();
      headers = {...?headers, 'Cookie': cookie};
    }
    return headers;
  }

  ///根据显示尺寸与设备像素比推导解码尺寸，避免全分辨率解码大图；
  ///width/height为Infinity/NaN/非正数时返回null（无法推导），避免round崩溃
  int? get _cacheWidth {
    if (widget.cacheWidth != null) return widget.cacheWidth;
    final w = widget.width;
    if (w == null || !w.isFinite || w <= 0) return null;
    final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 1.0;
    return (w * dpr).round();
  }

  int? get _cacheHeight {
    if (widget.cacheHeight != null) return widget.cacheHeight;
    final h = widget.height;
    if (h == null || !h.isFinite || h <= 0) return null;
    final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 1.0;
    return (h * dpr).round();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path.startsWith("http") || widget.path.startsWith("https")
        ? Image(
            // 用ResizeImage限制解码尺寸，避免全分辨率解码大图
            image: ResizeImage.resizeIfNeeded(_cacheWidth, _cacheHeight,
                CachedNetworkImageProvider(widget.path,
                    scale: widget.scale, headers: _headers)),
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder != null
                ? widget.loadingBuilder
                : widget.placeholder.isNullOrEmpty()
                    ? null
                    : (context, child, process) {
                        if (process == null) {
                          return child;
                        } else {
                          return Image.asset(
                            widget.placeholder ?? "",
                            width: widget.width,
                            height: widget.height,
                          );
                        }
                      },
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              if (BuildConfig.isDebug) {
                Log.d('ImageLoad', "error========>${error.toString()}");
              }
              return widget.errorImage.isNullOrEmpty()
                  ? Container(
                      width: widget.width,
                      height: widget.height,
                    )
                  : Image.asset(
                      widget.errorImage!,
                      width: widget.width,
                      height: widget.height,
                    );
            },
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            colorBlendMode: widget.colorBlendMode,
            fit: widget.fit,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
          )
        : widget.isAsset
            ? Image.asset(widget.path,
                scale: widget.scale,
                frameBuilder: widget.frameBuilder,
                package: widget.package,
                cacheWidth: _cacheWidth,
                cacheHeight: _cacheHeight,
                errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return widget.errorImage.isNullOrEmpty()
                    ? Container(
                        width: widget.width,
                        height: widget.height,
                      )
                    : Image.asset(
                        widget.errorImage!,
                        width: widget.width,
                        height: widget.height,
                      );
              },
                semanticLabel: widget.semanticLabel,
                excludeFromSemantics: widget.excludeFromSemantics,
                width: widget.width,
                height: widget.height,
                color: widget.color,
                colorBlendMode: widget.colorBlendMode,
                fit: widget.fit,
                alignment: widget.alignment,
                repeat: widget.repeat,
                centerSlice: widget.centerSlice,
                matchTextDirection: widget.matchTextDirection,
                gaplessPlayback: widget.gaplessPlayback,
                filterQuality: widget.filterQuality,
                isAntiAlias: widget.isAntiAlias)
            : Image.file(new File(widget.path),
                scale: widget.scale,
                frameBuilder: widget.frameBuilder,
                cacheWidth: _cacheWidth,
                cacheHeight: _cacheHeight,
                errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return widget.errorImage.isNullOrEmpty()
                    ? Container(
                        width: widget.width,
                        height: widget.height,
                      )
                    : Image.asset(
                        widget.errorImage!,
                        width: widget.width,
                        height: widget.height,
                      );
              },
                semanticLabel: widget.semanticLabel,
                excludeFromSemantics: widget.excludeFromSemantics,
                width: widget.width,
                height: widget.height,
                color: widget.color,
                colorBlendMode: widget.colorBlendMode,
                fit: widget.fit,
                alignment: widget.alignment,
                repeat: widget.repeat,
                centerSlice: widget.centerSlice,
                matchTextDirection: widget.matchTextDirection,
                gaplessPlayback: widget.gaplessPlayback,
                filterQuality: widget.filterQuality,
                isAntiAlias: widget.isAntiAlias);
  }
}

String formatImage(String name,
    {String format = ".png", String parentPath = "images"}) {
  return "${parentPath}/$name$format";
}
