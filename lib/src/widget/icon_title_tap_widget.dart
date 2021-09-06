import 'package:flutter/cupertino.dart';
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

class IconTitleWidget extends StatelessWidget {
  final Widget? image;
  final Icon? icon;
  final String name;
  double height;
  final Color color;
  final TextStyle? textStyle;
  final bool showArrow;
  final Widget? contentWidget;
  final EdgeInsets? padding;
  final bool isRequired;

  IconTitleWidget(this.name,
      {this.image,
        this.icon,
        this.height = 55,
        this.color = Colors.white,
        this.textStyle,
        this.contentWidget,
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
              indent: 10,
            ),
          ],
        )
            : image != null
            ? Row(
          children: <Widget>[
            image!,
            Divider(
              indent: 10,
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
                    ? textStyle?.fontSize ?? 15
                    : 15),
            children: [
              TextSpan(
                text: name,
                style: textStyle != null
                    ? textStyle
                    : TextStyle(
                    color: Colors.black,
                    fontSize: 15),
              )
            ])).setWeight(1)
            : Text(
          name,
          textAlign: TextAlign.start,
          style: textStyle != null
              ? textStyle
              : TextStyle(
              color: Colors.black, fontSize: 15),
        ).setWeight(1),
        contentWidget ?? Container(),
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(margin: EdgeInsets.only(left: 10))
            : Container()
      ],
    ).addToContainer(
        color: color,
        height: height,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(horizontal: 16));
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        image == null
            ? Container(
          width: 0,
        )
            : Row(
          children: <Widget>[
            Image.asset(
              image??"",
              width: 21,
              height: 21,
            ),
            Divider(
              indent: 10,
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
                    fontSize: nameStyle != null
                        ? textStyle?.fontSize ?? 16
                        : 16),
                children: [
                  TextSpan(
                    text: name,
                    style: nameStyle ??
                         TextStyle(
                        color: Colors.black,
                        fontSize: 16),
                  )
                ]),softWrap: true,):
            Text(
              name,
              style: nameStyle != null
                  ? nameStyle
                  : TextStyle(
                  color: Colors.black, fontSize: 16),
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
                  fontSize: 14),
          softWrap: true,
        ).setWeight(1)
            : Text(
          text,
          textAlign: TextAlign.right,
          style: textStyle ??
              TextStyle(
                  color: Colors.black,
                  fontSize: 14),
          softWrap: true,
        ).setWeight(1),
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(
            margin: EdgeInsets.only(left: 10))
            : Container()
      ],
    ).addToContainer(
        color: color,
        height: height,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(horizontal: 16))
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
              width: 21,
              height: 21,
            ),
            Divider(
              indent: 10,
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
                        ? textStyle?.fontSize ?? 16
                        : 16),
                children: [
                  TextSpan(
                    text: name,
                    style: textStyle != null
                        ? textStyle
                        : TextStyle(
                        color: Colors.black,
                        fontSize: 15),
                  )
                ]),softWrap: true,):
            Text(
              name,
              style: nameStyle != null
                  ? nameStyle
                  : TextStyle(
                  color: Colors.black, fontSize: 15),
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
                  fontSize: 14),
          softWrap: true,
        ).setWeight(1)
            : Text(
          text,
          textAlign: TextAlign.right,
          style: textStyle ??
              TextStyle(
                  color: Colors.black,
                  fontSize: 14),
          softWrap: true,
        ).setWeight(1),
        showArrow
            ? Icon(Icons.arrow_forward_ios_rounded)
            .addToContainer(
            margin: EdgeInsets.only(left: 10))
            : Container()
      ],
    ).addToContainer(
        color: color,
        padding: padding != null
            ? padding
            : EdgeInsets.symmetric(
            horizontal: 16, vertical:12));
  }
}
