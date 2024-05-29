import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  Widget? child;
  VoidCallback? onPressed;
  EdgeInsets? padding;
  OutlinedBorder? shape;

  OutlineButton({this.child, this.onPressed,this.padding,this.shape});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          padding: WidgetStateProperty
          .all(padding),
          shape: WidgetStateProperty.all(shape??RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))))),
    );
  }
}
