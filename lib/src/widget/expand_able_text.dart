import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  final bool expand;
  final Color expandColor;

  const ExpandableText(
      {Key key,
      this.text,
      this.maxLines,
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
  // final String text;
  // final int maxLines;
  // final TextStyle style;
  bool expand;
  // final Color expandColor;
  _ExpandableTextState( this.expand) {
    if (expand == null) {
      expand = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: widget.text ?? '', style: widget.style);
      final tp = TextPainter(
          text: span, maxLines: widget.maxLines, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) {
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
                        fontSize: widget.style != null ? widget.style.fontSize : null,
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
