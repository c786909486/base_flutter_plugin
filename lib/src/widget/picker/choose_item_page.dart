import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/widget/picker/choose_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base_flutter/src/utils/ext_utils.dart';

class ChooseItemPage<T extends ChooseItemModel> extends StatefulWidget {
  final List<T> itemData;
  final ThemeData themeData;
  final String title;
  final TextStyle titleStyle;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets padding;
  final Color itemBgColor;
  final bool wholeClick;

  ChooseItemPage(this.itemData, this.itemBuilder,
      {this.themeData,
      this.title = "请选择",
      this.padding = const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      this.titleStyle = const TextStyle(color: Colors.black, fontSize: 17),
      this.itemBgColor,
      this.wholeClick = true});

  @override
  State<StatefulWidget> createState() => _ChooseItemState<T>();

  static Future<List<T>> toChooseItemPage<T extends ChooseItemModel>({
    @required List<T> itemData,
    @required IndexedWidgetBuilder itemBuilder,
    @required BuildContext context,
    ThemeData themeData,
    String title = "请选择",
    TextStyle titleStyle = const TextStyle(color: Colors.black, fontSize: 18),
    EdgeInsets padding = const EdgeInsets.only(left: 16, top: 8, bottom: 8),
    Color itemBgColor = Colors.white,
    bool wholeClick = true,
  }) async {
    List<T> result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChooseItemPage<T>(
              itemData,
              itemBuilder,
              title: title,
              themeData: themeData,
              titleStyle: titleStyle,
              padding: padding,
              itemBgColor: itemBgColor,
              wholeClick: wholeClick,
            )));
    return result;
  }
}

class _ChooseItemState<T extends ChooseItemModel>
    extends State<ChooseItemPage<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title ?? "请选择",
          style: widget.titleStyle,
        ),
        iconTheme: widget.themeData != null
            ? widget.themeData.iconTheme
            : Theme.of(context).iconTheme,
        actionsIconTheme: widget.themeData != null
            ? widget.themeData.accentIconTheme
            : Theme.of(context).accentIconTheme,
        backgroundColor: widget.themeData != null
            ? widget.themeData.primaryColor
            : Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            ),
            iconSize: 32,
            onPressed: () {
              List<T> selectList = [];
              widget.itemData.forEach((element) {
                if (element.checked) {
                  selectList.add(element);
                }
              });
              Navigator.of(context).pop(selectList);
            },
          )
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            var item = widget.itemData[index];
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                widget.itemBuilder(context, index),
                Checkbox(
                    value: item.checked,
                    onChanged: (isChecked) {
                      setState(() {
                        item.checked = isChecked;
                      });
                    }).setLocation(right: 0)
              ],
            )
                .addToContainer(
                    padding: widget.padding, color: widget.itemBgColor)
                .onTap(() {
              if (widget.wholeClick) {
                setState(() {
                  item.checked = !item.checked;
                });
              }
            });
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Color(0xFF999999),
              height: 1,
            );
          },
          itemCount: widget.itemData.length),
    );
  }
}
