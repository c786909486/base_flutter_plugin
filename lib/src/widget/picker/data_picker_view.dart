import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSubmit<T> = void Function(T position1, T position2, T position3);

class DataPickerView {
  final List<IPickerData> first;
  List<List<IPickerData>>? second;
  List<List<List<IPickerData>>>? third;
  double? height;
  final BuildContext? context;
  Color? backgroundColor;
  Color? titleBarColor;
  late double itemExtent;
  TextStyle? cancelStyle;
  TextStyle? submitStyle;
  Widget? title;
  String? cancelText;
  String? submitText;
  late FixedExtentScrollController? firstScrollController;
  late FixedExtentScrollController? secondScrollController;
  late FixedExtentScrollController? thirdScrollController;
  final OnSubmit<int>? onSubmitListener;
  TextStyle? centerStyle;
  late IPickerData? currentFirstData;
  late IPickerData? currentSecondData;
  late IPickerData? currentThirdData;
  late int _firstSelection = 0;
  late int _secondSelection = 0;
  late int _thirdSelection = 0;

  static const List<int> _weight = [1, 1, 1];

  late List<int> flexs;

  DataPickerView(this.context, this.first,
      {Key? key,
      List<List<IPickerData>>? second,
      List<List<List<IPickerData>>>? third,
      this.onSubmitListener,
      Widget? title,
      String cancelText = "取消",
      String submitText = "确定",
      Color backgroundColor = Colors.white,
      Color titleBarColor = Colors.white,
      TextStyle? centerStyle,
      TextStyle? submitStyle,
      TextStyle? cancelStyle,
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
    this.title = title ?? Container();
    this.cancelStyle = cancelStyle;
    this.cancelText = cancelText;
    this.submitText = submitText;
    this.submitStyle = submitStyle;
    this.cancelStyle = cancelStyle;
    this.itemExtent = itemExtent;
    this.backgroundColor = backgroundColor;
    this.titleBarColor = titleBarColor;
    this.flexs = flexs;
    this.centerStyle = centerStyle;
    this.firstScrollController = firstScrollController;
  }

  void show() {
    // Navigator.push(
    //     context!,
    //     new _DataPickerRoute(
    //       first,
    //       second: second ?? [],
    //       third: third ?? [],
    //       onSubmitListener: onSubmitListener!,
    //       title: title,
    //       cancelText: cancelText ?? "取消",
    //       submitText: submitText ?? "确定",
    //       backgroundColor: backgroundColor ?? Colors.white,
    //       titleBarColor: titleBarColor ?? Colors.white,
    //       centerStyle: centerStyle,
    //       submitStyle: submitStyle,
    //       cancelStyle: cancelStyle,
    //       flexs: flexs,
    //       barrierLable:
    //           MaterialLocalizations.of(context!).modalBarrierDismissLabel,
    //       currentFirstData: currentFirstData,
    //       currentSecondData: currentSecondData,
    //       currentThirdData: currentThirdData,
    //       itemExtent: itemExtent,
    //     ));
    showCupertinoModalPopup(
        context: context!,
        builder: (context) {
          return MyPicker(
            first: first,
            second: second ?? [],
            third: third ?? [],
            onSubmitListener: onSubmitListener!,
            title: title,
            cancelText: cancelText??"取消",
            submitText: submitText??"确定",
            backgroundColor: backgroundColor??Colors.white,
            titleBarColor: titleBarColor??Colors.white,
            centerStyle: centerStyle,
            submitStyle: submitStyle,
            cancelStyle: cancelStyle,
            flexs: flexs,
            currentFirstData: currentFirstData,
            currentSecondData: currentSecondData,
            currentThirdData: currentThirdData,
            itemExtent: itemExtent,
          );
        });
  }
}

class _DataPickerRoute<T> extends PopupRoute<T> {
  final List<IPickerData> first;
  List<List<IPickerData>>? second;
  List<List<List<IPickerData>>>? third;
  double? height;
  Color? backgroundColor;
  Color? titleBarColor;
  late double itemExtent;
  TextStyle? cancelStyle;
  TextStyle? submitStyle;
  Widget? title;
  String? cancelText;
  String? submitText;
  late FixedExtentScrollController? firstScrollController;
  late FixedExtentScrollController? secondScrollController;
  late FixedExtentScrollController? thirdScrollController;
  final OnSubmit<int>? onSubmitListener;
  TextStyle? centerStyle;
  late IPickerData? currentFirstData;
  late IPickerData? currentSecondData;
  late IPickerData? currentThirdData;
  late int _firstSelection = 0;
  late int _secondSelection = 0;
  late int _thirdSelection = 0;
  String? barrierLable;

  static const List<int> _weight = [1, 1, 1];

  late List<int> flexs;

  _DataPickerRoute(this.first,
      {List<List<IPickerData>>? second,
      List<List<List<IPickerData>>>? third,
      this.onSubmitListener,
      Widget? title,
      String cancelText = "取消",
      String submitText = "确定",
      Color backgroundColor = Colors.white,
      Color titleBarColor = Colors.white,
      TextStyle? centerStyle,
      TextStyle? submitStyle,
      TextStyle? cancelStyle,
      List<int> flexs = _weight,
      this.firstScrollController,
      this.secondScrollController,
      this.thirdScrollController,
      this.currentFirstData,
      this.currentSecondData,
      this.currentThirdData,
      this.barrierLable = "",
      double itemExtent = 40}) {
    this.second = second;
    this.third = third;
    this.height = height;
    this.title = title ?? Container();
    this.cancelStyle = cancelStyle;
    this.cancelText = cancelText;
    this.submitText = submitText;
    this.submitStyle = submitStyle;
    this.cancelStyle = cancelStyle;
    this.itemExtent = itemExtent;
    this.backgroundColor = backgroundColor;
    this.titleBarColor = titleBarColor;
    this.flexs = flexs;
    this.centerStyle = centerStyle;
    this.firstScrollController = firstScrollController;
  }

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }



  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => barrierLable;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);


  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: MyPicker(
        first: first,
        second: second ?? [],
        third: third ?? [],
        onSubmitListener: onSubmitListener!,
        title: title,
        cancelText: cancelText ?? "取消",
        submitText: submitText ?? "确定",
        backgroundColor: backgroundColor ?? Colors.white,
        titleBarColor: titleBarColor ?? Colors.white,
        centerStyle: centerStyle,
        submitStyle: submitStyle,
        cancelStyle: cancelStyle,
        flexs: flexs,
        currentFirstData: currentFirstData,
        currentSecondData: currentSecondData,
        currentThirdData: currentThirdData,
        itemExtent: itemExtent,
      ),
    );
    ThemeData inheritTheme = Theme.of(context);
    if (inheritTheme != null) {
      bottomSheet = new Theme(data: inheritTheme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class MyPicker extends StatefulWidget {
  final List<IPickerData>? first;
  List<List<IPickerData>>? second;
  List<List<List<IPickerData>>>? third;
  double? height;
  late Color backgroundColor;
  late Color titleBarColor;
  double? itemExtent;
  TextStyle? cancelStyle;
  TextStyle? submitStyle;
  Widget? title;
  String? cancelText = "取消";
  String? submitText = "确定";
  final OnSubmit<int>? onSubmitListener;
  TextStyle? centerStyle;
  late IPickerData? currentFirstData;
  late IPickerData? currentSecondData;
  late IPickerData? currentThirdData;
  int _firstSelection = 0;
  int _secondSelection = 0;
  int _thirdSelection = 0;

  static const List<int> _weight = [1, 1, 1];

  List<int>? flexs;

  MyPicker(
      {Key? key,
      this.first,
      List<List<IPickerData>>? second,
      List<List<List<IPickerData>>>? third,
      this.onSubmitListener,
      Widget? title,
      String cancelText = "取消",
      String submitText = "确定",
      Color backgroundColor = Colors.white,
      Color titleBarColor = Colors.white,
      TextStyle? centerStyle,
      TextStyle? submitStyle,
      TextStyle? cancelStyle,
      List<int> flexs = _weight,
      this.currentFirstData,
      this.currentSecondData,
      this.currentThirdData,
      double itemExtent = 40}) {
    this.second = second;
    this.third = third;
    this.height = height;
    this.title = title ?? Container();
    this.cancelText = cancelText;
    this.submitText = submitText;
    this.submitStyle = submitStyle;
    this.cancelStyle = cancelStyle;
    this.itemExtent = itemExtent;
    this.backgroundColor = backgroundColor;
    this.titleBarColor = titleBarColor;
    this.flexs = flexs;
    this.centerStyle = centerStyle;
  }

  @override
  State<StatefulWidget> createState() => _MyPickerWidget();
}

class _MyPickerWidget extends State<MyPicker> {
  FixedExtentScrollController? defaultFirstController;
  FixedExtentScrollController? defaultSecondController;
  FixedExtentScrollController? defaultThirdController;

  @override
  void initState() {
    super.initState();
    defaultFirstController = new FixedExtentScrollController();
    defaultSecondController = new FixedExtentScrollController();
    defaultThirdController = new FixedExtentScrollController();

    if (widget.currentFirstData != null) {
      int current = widget.first!.indexOf(widget.currentFirstData!);
      defaultFirstController =
          new FixedExtentScrollController(initialItem: current);
      widget._firstSelection = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.titleBarColor,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text(
                  widget.cancelText ?? "取消",
                  style: widget.cancelStyle == null
                      ? TextStyle(color: Colors.grey, fontSize: 16)
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
                  widget.submitText ?? "确定",
                  style: widget.submitStyle == null
                      ? TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16)
                      : widget.submitStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onSubmitListener!(widget._firstSelection,
                      widget._secondSelection, widget._thirdSelection);
                },
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: widget.flexs![0],
                  child: CupertinoPicker(
                    scrollController: defaultFirstController,
                    backgroundColor: widget.backgroundColor,
                    children: widget.first!.map((item) {
                      return Center(
                        child: Text(
                          item.name,
                          style: widget.centerStyle == null
                              ? TextStyle(fontSize: 17)
                              : widget.centerStyle,
                        ),
                      );
                    }).toList(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        widget._firstSelection = index;
                        if (widget.second != null) {
                          defaultSecondController?.jumpToItem(0);
                        }
                        if (widget.third != null) {
                          defaultThirdController?.jumpToItem(0);
                        }
                      });
                    },
                    itemExtent: widget.itemExtent!,
                  ),
                ),
                widget.second == null || widget.second!.isEmpty
                    ? Container()
                    : Expanded(
                        flex: widget.flexs![1],
                        child: CupertinoPicker(
                          backgroundColor: widget.backgroundColor,
                          scrollController: defaultSecondController,
                          children:
                              widget.second == null || widget.second!.isEmpty
                                  ? []
                                  : widget.second![widget._firstSelection]
                                      .map((item) {
                                      return Center(
                                        child: Text(
                                          item.name,
                                          style: widget.centerStyle == null
                                              ? TextStyle(fontSize: 17)
                                              : widget.centerStyle,
                                        ),
                                      );
                                    }).toList(),
                          onSelectedItemChanged: (index) {
                            widget._secondSelection = index;
                            setState(() {
                              if (widget.third != null) {
                                defaultThirdController!.jumpToItem(0);
                              }
                            });
                          },
                          itemExtent: widget.itemExtent!,
                        ),
                      ),
                widget.third == null || widget.third!.isEmpty
                    ? Container()
                    : Expanded(
                        flex: widget.flexs![2],
                        child: CupertinoPicker(
                          scrollController: defaultThirdController,
                          backgroundColor: widget.backgroundColor,
                          children:
                              widget.third == null || widget.third!.isEmpty
                                  ? []
                                  : widget.third![widget._firstSelection]
                                          [widget._secondSelection]
                                      .map((item) {
                                      return Center(
                                        child: Text(
                                          item.name,
                                          style: widget.centerStyle == null
                                              ? TextStyle(fontSize: 17)
                                              : widget.centerStyle,
                                        ),
                                      );
                                    }).toList(),
                          onSelectedItemChanged: (index) {
                            widget._thirdSelection = index;
                          },
                          itemExtent: widget.itemExtent!,
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
  String name = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IPickerData &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class PickerDataWithIdModel implements IPickerData {
  String? pickName;
  String? pickId;

  PickerDataWithIdModel({this.pickName, this.pickId});

  @override
  String get name => pickName ?? "";

  @override
  set name(String _name) {}
}
