import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class BaseListViewModel<T> extends BaseViewModel {
  BaseListViewModel(BuildContext context) : super(context);

  List<T> listItems = [];
  RefreshController? controller = new RefreshController();

  var startDateStr = "";
  var endDateStr = "";
  DateTime? startDateTime;
  DateTime? endDateTime;

  @override
  void onCreated() {
    if(controller==null){
      controller = new RefreshController();
    }
    super.onCreated();

  }

  void setSearchDateRange(String _startTime, String _endTime) {
    var start = _startTime.toDate();
    var end = _endTime.toDate();
    if (start == null || end == null) {
      throw ("传入格式错误");
    }
    if (start.isAfter(end)) {
      throw ('设置的开始时间晚于结束时间');
    }
    startDateStr = _startTime;
    endDateStr = _endTime;
    startDateTime = start;
    endDateTime = end;
  }

  void selectStartDate({
    DateTime? min,
    DateTime? max,
    String title = "",
    List<String> formats = const [yyyy,'-',mm,'-',dd],
    Function(String date)? click
  }) {
    DatePicker.showDatePicker(context,
        currentTime: startDateTime,
        minTime: min,
        maxTime: max,
        title: title,
        onConfirm: (date) {
          if(endDateTime!=null){
            if(date!.isAfter(endDateTime!)){
              showToast('开始时间不可晚于结束时间');
              return;
            }
            startDateTime = date;
            startDateStr = startDateTime!.toDateStr(formats);
            notifyListeners();
            if(click!=null){
              click(startDateStr);
            }
          }else{
            startDateTime = date;
            startDateStr = startDateTime!.toDateStr(formats);
            notifyListeners();
            if(click!=null){
              click(startDateStr);
            }
          }
        });
  }

  void selectEndDate({
    DateTime? min,
    DateTime? max,
    String title = "",
    List<String> formats = const [yyyy,'-',mm,'-',dd],
    Function(String date)? click
  }) {
    DatePicker.showDatePicker(context,
        currentTime: endDateTime,
        minTime: min,
        maxTime: max,
        title: title,
        onConfirm: (date) {
          if(startDateTime!=null){
            if(date!.isBefore(startDateTime!)){
              showToast('结束时间不可早于开始时间');
              return;
            }
            endDateTime = date;
            endDateStr = endDateTime!.toDateStr(formats);
            notifyListeners();
            if(click!=null){
              click(endDateStr);
            }
          }else{
            endDateTime = date;
            endDateStr = endDateTime!.toDateStr(formats);
            notifyListeners();
            if(click!=null){
              click(endDateStr);
            }
          }
        });
  }
  var page = 1;

  var pageLength = 20;

  Future<List<T>> requestListData();

  var _inProcess = false;

  Future<void> requestRefresh({bool showAni = true}) async {
    if(_inProcess){
      return;
    }
    _inProcess = true;
    page = 1;
    if (listItems.isEmpty||loadingState==LoadingState.showEmpty||loadingState==LoadingState.showError) {
      showLoadingState();
    }
    if (showAni) {
      if (loadingState == LoadingState.showContent) {
        controller?.headerMode?.value = RefreshStatus.refreshing;
      }
    }

    try {
      var list = await requestListData();
      controller?.refreshCompleted();
      if (list.isNotEmpty) {
        page++;
        listItems = list;
        showContent();
        notifyListeners();
      } else {
        showEmptyState();
      }
      _inProcess = false;
    } catch (e) {
      _inProcess = false;
      controller?.refreshCompleted();
      showErrorState(e.toNetError());
      if (BuildConfig.isDebug&&mounted) {
        Log.d('requestError', e.toString(), current: StackTrace.current);
      }

    }
  }

  Future<void> requestLoadMore() async {
    try {
      var list = await requestListData();
      controller?.loadComplete();
      if (list.isNotEmpty) {
        page++;
        listItems.addAll(list);
        showContent();
        notifyListeners();
      } else {
        showToast("暂无更多数据");
      }
    } catch (e) {
      controller?.loadComplete();
      showToast(e.toNetError());
      if (BuildConfig.isDebug&&mounted) {
        Log.d('requestError', e.toString(), current: StackTrace.current);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onDispose() {
    controller = null;
    listItems.clear();
    startDateStr = "";
    endDateStr = "";
    startDateTime = null;
    endDateTime = null;
    super.onDispose();
  }
}
