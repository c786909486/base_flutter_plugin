import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnSubmit<T> = void Function(T position1, T position2, T position3);

class DataPickerView {
  final List<IPickerData> first;
  List<List<IPickerData>> second;
  List<List<List<IPickerData>>> third;
  double height;
  final BuildContext context;
  Color backgroundColor;
  Color titleBarColor;
  double itemExtent;
  TextStyle cancelStyle;
  TextStyle submitStyle;
  Widget title;
  String cancelText;
  String submitText;
  FixedExtentScrollController firstScrollController;
  FixedExtentScrollController secondScrollController;
  FixedExtentScrollController thirdScrollController;
  final OnSubmit<int> onSubmitListener;
  TextStyle centerStyle;
  IPickerData currentFirstData;
  IPickerData currentSecondData;
  IPickerData currentThirdData;
  int _firstSelection = 0;
  int _secondSelection = 0;
  int _thirdSelection = 0;

  static const List<int> _weight = [1, 1, 1];

  List<int> flexs;



  DataPickerView({Key key,
    this.context,
    this.first,
    List<List> second,
    List<List<List>> third,
    this.onSubmitListener,
    Widget title,
    String cancelText,
    String submitText,
    Color backgroundColor = Colors.white,
    Color titleBarColor = Colors.white,
    TextStyle centerStyle,
    TextStyle submitStyle,
    List<int> flexs = _weight,
    this.firstScrollController,
    this.secondScrollController,
    this.thirdScrollController,
    this.currentFirstData,
    this.currentSecondData,
    this.currentThirdData,
    double itemExtent = 40}) {
    this.second = second;
    this.third = third;
    this.height = height;
    this.title = title;
    this.cancelStyle = cancelStyle;
    this.cancelText = cancelText;
    this.submitText = submitText;
    this.submitStyle = submitStyle;
    this.itemExtent = itemExtent;
    this.backgroundColor = backgroundColor;
    this.titleBarColor = titleBarColor;
    this.flexs = flexs;
    this.centerStyle = centerStyle;
    this.firstScrollController = firstScrollController;

  }

  void show() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return MyPicker(first: first,second: second,third: third,onSubmitListener: onSubmitListener,title: title,
          cancelText: cancelText,submitText: submitText,backgroundColor: backgroundColor,titleBarColor: titleBarColor,centerStyle: centerStyle,
          submitStyle: submitStyle,flexs: flexs,
          currentFirstData: currentFirstData,currentSecondData: currentSecondData,currentThirdData: currentThirdData,itemExtent: itemExtent,);
        });
  }
}

class MyPicker extends StatefulWidget{
  final List<IPickerData> first;
  List<List<IPickerData>> second;
  List<List<List<IPickerData>>> third;
  double height;
  Color backgroundColor;
  Color titleBarColor;
  double itemExtent;
  TextStyle cancelStyle;
  TextStyle submitStyle;
  Widget title;
  String cancelText;
  String submitText;
  final OnSubmit<int> onSubmitListener;
  TextStyle centerStyle;
  IPickerData currentFirstData;
  IPickerData currentSecondData;
  IPickerData currentThirdData;
  int _firstSelection = 0;
  int _secondSelection = 0;
  int _thirdSelection = 0;

  static const List<int> _weight = [1, 1, 1];

  List<int> flexs;

  MyPicker({Key key,

    this.first,
    List<List> second,
    List<List<List>> third,
    this.onSubmitListener,
    Widget title,
    String cancelText,
    String submitText,
    Color backgroundColor = Colors.white,
    Color titleBarColor = Colors.white,
    TextStyle centerStyle,
    TextStyle submitStyle,
    List<int> flexs = _weight,
    this.currentFirstData,
    this.currentSecondData,
    this.currentThirdData,
    double itemExtent = 40}) {
    this.second = second;
    this.third = third;
    this.height = height;
    this.title = title;
    this.cancelStyle = cancelStyle;
    this.cancelText = cancelText;
    this.submitText = submitText;
    this.submitStyle = submitStyle;
    this.itemExtent = itemExtent;
    this.backgroundColor = backgroundColor;
    this.titleBarColor = titleBarColor;
    this.flexs = flexs;
    this.centerStyle = centerStyle;
  }
  @override
  State<StatefulWidget> createState() =>_MyPickerWidget();

}

class _MyPickerWidget extends State<MyPicker>{
  FixedExtentScrollController defaultFirstController;
  FixedExtentScrollController defaultSecondController;
  FixedExtentScrollController defaultThirdController;

  @override
  void initState() {
    super.initState();
    defaultFirstController = new FixedExtentScrollController();
    defaultSecondController= new FixedExtentScrollController();
    defaultThirdController= new FixedExtentScrollController();

    if(widget.currentFirstData!=null){
      int current = widget.first.indexOf(widget.currentFirstData);
     defaultFirstController = new FixedExtentScrollController(initialItem: current);
     widget._firstSelection = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.titleBarColor,
      height: MediaQuery
          .of(context)
          .size
          .height / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text(
                  widget.cancelText == null || widget.cancelText.isEmpty
                      ? "取消"
                      : widget.cancelText,
                  style: widget.cancelStyle == null
                      ? TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil.getInstance().setSp(32))
                      : widget.cancelStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                flex: 1,
                child: widget.title == null
                    ? Container()
                    : Center(
                  child: widget.title,
                ),
              ),
              FlatButton(
                child: Text(
                  widget.submitText == null || widget.submitText.isEmpty
                      ? "确定"
                      : widget.submitText,
                  style: widget.submitStyle == null
                      ? TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: ScreenUtil.getInstance().setSp(32))
                      : widget.submitStyle,
                ),
                onPressed: () {
                  widget.onSubmitListener(
                      widget._firstSelection, widget._secondSelection, widget._thirdSelection);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: widget.flexs[0],
                  child: CupertinoPicker(

                    scrollController:defaultFirstController,
                    backgroundColor: widget.backgroundColor,
                    children: widget.first.map((item) {
                      return Center(
                        child: Text(
                          item.name,
                          style: widget.centerStyle == null
                              ? TextStyle(
                              fontSize:
                              ScreenUtil.getInstance().setSp(34))
                              : widget.centerStyle,
                        ),
                      );
                    }).toList(),
                    onSelectedItemChanged: (index) {
                     setState(() {
                       widget._firstSelection = index;
                       if(widget.second!=null){
                         defaultSecondController.jumpToItem(0);
                       }
                       if(widget.third!=null){
                         defaultThirdController.jumpToItem(0);
                       }
                     });
                    },
                    itemExtent: widget.itemExtent,
                  ),
                ),
                widget.second == null
                    ? Container()
                    : Expanded(
                  flex: widget.flexs[1],
                  child: CupertinoPicker(
                    backgroundColor: widget.backgroundColor,
                    scrollController: defaultSecondController,
                    children: widget.second[widget._firstSelection].map((item) {
                      return Center(
                        child: Text(
                          item.name,
                          style: widget.centerStyle == null
                              ? TextStyle(
                              fontSize: ScreenUtil.getInstance()
                                  .setSp(34))
                              : widget.centerStyle,
                        ),
                      );
                    }).toList(),
                    onSelectedItemChanged: (index) {
                      widget. _secondSelection = index;
                      setState(() {
                        if(widget.third!=null){
                          defaultThirdController.jumpToItem(0);
                        }
                      });
                    },
                    itemExtent: widget.itemExtent,
                  ),
                ),
                widget.third == null
                    ? Container()
                    : Expanded(
                  flex: widget.flexs[2],
                  child: CupertinoPicker(
                    scrollController: defaultThirdController,
                    backgroundColor: widget.backgroundColor,
                    children: widget.third[widget._firstSelection]
                    [widget._secondSelection]
                        .map((item) {
                      return Center(
                        child: Text(
                          item.name,
                          style: widget.centerStyle == null
                              ? TextStyle(
                              fontSize: ScreenUtil.getInstance()
                                  .setSp(34))
                              : widget.centerStyle,
                        ),
                      );
                    }).toList(),
                    onSelectedItemChanged: (index) {
                      widget._thirdSelection = index;
                    },
                    itemExtent: widget.itemExtent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class IPickerData {
  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IPickerData &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;
}
