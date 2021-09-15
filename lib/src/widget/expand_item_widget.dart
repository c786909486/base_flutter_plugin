import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:base_flutter/src/utils/ext_utils.dart';
import 'package:flutter/material.dart';

class ExpandItemWidget extends StatelessWidget {
  final Widget contentWidget;
  final Widget childWidget;
  final Color? backgroundColor;

  ExpandItemWidget({required this.contentWidget,required this.childWidget,this.backgroundColor = Colors.white});

  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          Row(
            children: [
              contentWidget.setWeight(1),
              !isExpanded
                  ? Icon(Icons.arrow_forward_ios_rounded)
                  : Transform.rotate(
                      angle: pi/2 ,
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    )
            ],
          ).addToContainer(
              padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          )).onTap(() {
            setState((){
              isExpanded = !isExpanded;
            });
          }),
          isExpanded?childWidget:Container()
        ],
      ).addToContainer(color: backgroundColor);
    });
  }
}
