import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/material.dart';

class BuildConfig {
  static bool _inProduction = const bool.fromEnvironment("dart.vm.product");

  static bool get isDebug => !_inProduction;

  static List<Widget> pageList = [];
}

String getImagePath(String name,
    {String format = "png", String parent = "images"}) {
  return "${parent}/$name.$format";
}

/// 默认dialog背景色为半透明黑色，这里修改源码改为透明
Future showTransparentDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: const Color(0x00FFFFFF),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Future showElasticDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(
    context,
  );
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: _buildDialogTransitions,
  );
}

Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: animation,
        curve: animation.status != AnimationStatus.forward
            ? Curves.easeOutBack
            : ElasticOutCurve(0.85),
      )),
      child: child,
    ),
  );
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: 24.0,
        height: 24.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

showBottomSelect(BuildContext context,
    {required List<String> items, String title = '请选择',Function(String select)? onSelect }) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        var contentList = items
            .map((e) => CommonText(e, textAlign: TextAlign.center)
            .addToContainer(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 13))
            .onTap(() {
          Navigator.pop(context);
          if (onSelect != null) {
            onSelect(e);
          }
        }))
            .toList()
            .insertWidget(Divider(
          color: Colors.grey,
          height: 1,
        ));

        return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    CommonText(title, textAlign: TextAlign.center).addToContainer(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    ...contentList
                  ],
                ).addToContainer(decoration: BoxDecoration(color: Colors.white,borderRadius: 10.borderRadius),
                    margin: EdgeInsets.symmetric(horizontal: 16)),
                CommonText('取消', textColor: Colors.red)
                    .addToContainer(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: 10.borderRadius))
                    .onTap(() {
                  Navigator.pop(context);
                })
              ],
            ));
      });
}

showBottomSelectSheet<T extends IPickerData>(BuildContext context,
    {required List<T> items, String title = '请选择',Function(T select)? onSelect }) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        var list = <Widget>[
          CommonText(title)
              .addToContainer(padding: EdgeInsets.symmetric(vertical: 10)),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
        ];
        items.forEach((element) {
          list.add(CommonText(element.name)
              .addToContainer(padding: EdgeInsets.symmetric(vertical: 10))
              .onTap(() {
            Navigator.pop(context);
            if(onSelect!=null){
              onSelect(element);
            }
          }));
          list.add(Divider(
            color: Colors.grey,
            height: 1,
          ));
        });

        list.addAll([
          Container(
            height: 10,
            color: Colors.grey[200],
          ),
          CommonText('取消', textColor: Theme.of(context).primaryColor)
              .addToContainer(padding: EdgeInsets.symmetric(vertical: 10))
              .onTap(() {
            Navigator.pop(context);
          })
        ]);
        return SafeArea(child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: list,
        )).addToContainer(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: 20.radius, topLeft: 20.radius)));
      });
}
