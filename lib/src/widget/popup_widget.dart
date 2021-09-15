import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final Widget child;
  final Function? onClick; //点击child事件
  final double? left; //距离左边位置
  final double? top; //距离上面位置
  final double? right;
  final GlobalKey parentKey;

  Popup({
    required this.child,
    required this.parentKey,
    this.onClick,
    this.left,
    this.top,
    this.right
  });

   Offset _getPosition() {

    RenderBox? renderBox = parentKey.currentContext?.findRenderObject() as RenderBox?;
    final positionGreen = renderBox?.localToGlobal(Offset.zero);
    print(positionGreen.toString());
    return positionGreen!;
  }


  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              child: GestureDetector(
                  child: child,
                  onTap: () {
                    //点击子child
                    if (onClick != null) {
                      Navigator.of(context).pop();
                      if (onClick != null) {
                        onClick!();
                      }
                    }
                  }),
              left: left==null?null:_getPosition().dx+(left??0),
              top: _getPosition().dy+(top??0),
              right: right,
            ),
          ],
        ),
        onTap: () {
          //点击空白处
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

showPopupWindow(BuildContext context,Popup child,{double left = 0,double top = 0}){
  Navigator.of(context).push(PopRoute(child: child));
}

class PopRoute extends PopupRoute{
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;

}
