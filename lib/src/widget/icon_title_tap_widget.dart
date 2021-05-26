import 'package:flutter/cupertino.dart';
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

class IconTitleWidget extends StatelessWidget {
  final String? image;
  final Icon? icon;
  final String name;
  double height;
  final Color color;
  final TextStyle? textStyle;
  final bool showArrow;
  final Widget contentWidget;
  final EdgeInsets? padding;
  final bool isRequired;

  IconTitleWidget(this.name,
      {this.image,
        this.icon,
        this.height = 55,
        this.color = Colors.white,
        this.textStyle,
        required this.contentWidget,
        this.padding,
        this.showArrow = true,
        this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon != null
            ? Row(
          children: <Widget>[
            icon??Container(),
            Divider(
              indent: 20.0.fitWidth(),
            ),
          ],
        )
            : image != null
            ? Row(
          children: <Widget>[
            Image.asset(
              image??"",
              width: 42.0.fitWidth(),
              height: 42.0.fitWidth(),
            ),
            Divider(
              indent: 20.0.fitWidth(),
            ),
          ],
        )
            : Container(),
        isRequired
            ? Text.rich(TextSpan(
            text: "*",
            style: TextStyle(
                color: Colors.red,
                fontSize: textStyle != null
                    ? textStyle?.fontSize ?? 30.0.fitSp()
                    : 30.0.fitSp()),
            children: [
              TextSpan(
                text: name,
                style: textStyle != null
                    ? textStyle
                    : TextStyle(
                    color: Colors.black,
                    fontSize: 30.0.fitSp()),
              )
            ])).setWeight(1)
            : Text(
          name,
          style: textStyle != null
              ? textStyle
              : TextStyle(
              color: Colors.black, fontSize: 30.0.fitSp()),
        ).setWeight(1),
        contentWidget == null ? Container() : contentWidget,
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(margin: EdgeInsets.only(left: 20.0.fitWidth()))
            : Container()
      ],
    ).addToContainer(
        color: color,
        height: height,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(horizontal: 32.0.fitWidth()));
  }
}

class IconTitleTextWidget extends StatelessWidget {
  final String? image;
  final String name;
  double height;
  final Color color;
  final TextStyle? nameStyle;
  final bool showArrow;
  final EdgeInsets? padding;
  final String text;
  final String hintText;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool isRequired;

  IconTitleTextWidget(this.name,
      {this.image,
        this.height = 55,
        this.color = Colors.white,
        this.nameStyle,
        this.text="",
        this.hintText = "",
        this.padding,
        this.hintTextStyle,
        this.textStyle,
        this.showArrow = true,
        this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return height > 0
        ? Row(
      children: <Widget>[
        image == null
            ? Container(
          width: 0,
        )
            : Row(
          children: <Widget>[
            Image.asset(
              image??"",
              width: 42.0.fitWidth(),
              height: 42.0.fitWidth(),
            ),
            Divider(
              indent: 20.0.fitWidth(),
            ),
          ],
        ),
        Wrap(
          children: [
            isRequired?
            Text.rich(TextSpan(
                text: "*",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: textStyle != null
                        ? textStyle?.fontSize ?? 32.0.fitSp()
                        : 32.0.fitSp()),
                children: [
                  TextSpan(
                    text: name,
                    style: textStyle != null
                        ? textStyle
                        : TextStyle(
                        color: Colors.black,
                        fontSize: 30.0.fitSp()),
                  )
                ]),softWrap: true,):
            Text(
              name,
              style: nameStyle != null
                  ? nameStyle
                  : TextStyle(
                  color: Colors.black, fontSize: 30.0.fitSp()),
              softWrap: true,
            )
          ],
        ),
        Divider(
          color: Colors.transparent,
          indent: 8,
        ),
        text.isNullOrEmpty()
            ? Text(
          hintText,
          textAlign: TextAlign.right,
          style: hintTextStyle ??
              TextStyle(
                  color: Colors.grey,
                  fontSize: 28.0.fitSp()),
          softWrap: true,
        ).setWeight(1)
            : Text(
          text,
          textAlign: TextAlign.right,
          style: textStyle ??
              TextStyle(
                  color: Colors.black,
                  fontSize: 28.0.fitSp()),
          softWrap: true,
        ).setWeight(1),
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(
            margin: EdgeInsets.only(left: 20.0.fitWidth()))
            : Container()
      ],
    ).addToContainer(
        color: color,
        height: height,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(horizontal: 32.0.fitWidth()))
        : Row(
      children: <Widget>[
        image == null
            ? Container(
          width: 0,
        )
            : Row(
          children: <Widget>[
            Image.asset(
              image??"",
              width: 42.0.fitWidth(),
              height: 42.0.fitWidth(),
            ),
            Divider(
              indent: 20.0.fitWidth(),
            ),
          ],
        ),
        Wrap(
          children: [
            isRequired?
            Text.rich(TextSpan(
                text: "*",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: textStyle != null
                        ? textStyle?.fontSize ?? 32.0.fitSp()
                        : 32.0.fitSp()),
                children: [
                  TextSpan(
                    text: name,
                    style: textStyle != null
                        ? textStyle
                        : TextStyle(
                        color: Colors.black,
                        fontSize: 30.0.fitSp()),
                  )
                ]),softWrap: true,):
            Text(
              name,
              style: nameStyle != null
                  ? nameStyle
                  : TextStyle(
                  color: Colors.black, fontSize: 30.0.fitSp()),
              softWrap: true,
            )
          ],
        ),
        Divider(
          color: Colors.transparent,
          indent: 8,
        ),
        text.isNullOrEmpty()
            ? Text(
          hintText,
          textAlign: TextAlign.right,
          style: hintTextStyle ??
              TextStyle(
                  color: Colors.grey,
                  fontSize: 28.0.fitSp()),
          softWrap: true,
        ).setWeight(1)
            : Text(
          text,
          textAlign: TextAlign.right,
          style: textStyle ??
              TextStyle(
                  color: Colors.black,
                  fontSize: 28.0.fitSp()),
          softWrap: true,
        ).setWeight(1),
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(
            margin: EdgeInsets.only(left: 20.0.fitWidth()))
            : Container()
      ],
    ).addToContainer(
        color: color,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(
            horizontal: 32.0.fitWidth(), vertical: 25.0.fitWidth()));
  }
}
