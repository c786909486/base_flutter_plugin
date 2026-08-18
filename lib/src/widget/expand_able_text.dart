import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String? text;
  final int maxLines;
  final TextStyle? style;
  final bool expand;
  final Color? expandColor;

  const ExpandableText(
      {Key? key,
      this.text = "",
      this.maxLines = 1,
      this.style,
      this.expand = false,
      this.expandColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExpandableTextState(expand);
  }
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expand;
  _ExpandableTextState(this.expand);

  ///缓存的测量结果：避免滚动/重建时重复执行昂贵的 TextPainter.layout
  bool? _didExceed;
  double? _layoutWidth;
  String? _layoutText;
  int? _layoutMaxLines;
  TextStyle? _layoutStyle;

  @override
  void didUpdateWidget(ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 文本/行数/样式任一变化时，缓存失效，下次build重新测量
    if (oldWidget.text != widget.text ||
        oldWidget.maxLines != widget.maxLines ||
        oldWidget.style != widget.style) {
      _didExceed = null;
    }
  }

  bool _needsLayout(double maxWidth) {
    return _didExceed == null ||
        _layoutWidth != maxWidth ||
        _layoutText != widget.text ||
        _layoutMaxLines != widget.maxLines ||
        _layoutStyle != widget.style;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      if (_needsLayout(size.maxWidth)) {
        final span = TextSpan(text: widget.text ?? '', style: widget.style);
        final tp = TextPainter(
            text: span,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size.maxWidth);
        _didExceed = tp.didExceedMaxLines;
        _layoutWidth = size.maxWidth;
        _layoutText = widget.text;
        _layoutMaxLines = widget.maxLines;
        _layoutStyle = widget.style;
      }

      if (_didExceed!) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            expand
                ? Text(widget.text ?? '', style: widget.style)
                : Text(widget.text ?? '',
                    maxLines: widget.maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: widget.style),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  expand = !expand;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 6),
                child: Text(widget.expand ? '收起' : '全文',
                    style: TextStyle(
                        fontSize: widget.style != null ? widget.style?.fontSize : null,
                        color: widget.expandColor ?? Colors.blue)),
              ),
            ),
          ],
        );
      } else {
        return Text(widget.text ?? '', style: widget.style);
      }
    });
  }
}
