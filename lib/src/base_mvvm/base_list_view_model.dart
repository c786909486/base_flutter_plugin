import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class BaseListViewModel<T> extends BaseViewModel{
  BaseListViewModel(BuildContext context) : super(context);

  List<T> listItems = [];
  RefreshController controller = new RefreshController();

  var page = 1;

  var pageLength = 20;

  Future<List<T>> requestListData();

  Future<void> requestRefresh({bool showAni = true}) async {
    page = 1;
    if(listItems.isEmpty){
      showLoadingState();
    }
    if(showAni){
      if(loadingState==LoadingState.showContent){
        controller.requestRefresh(needCallback: false);
      }
    }

    try{
      var list = await requestListData();
      controller.refreshCompleted();
      if(list.isNotEmpty){
        page++;
        listItems = list;
        showContent();
        notifyListeners();

      }else{
       showEmptyState();
      }
    }catch(e){
      controller.refreshCompleted();
      showErrorState(e.toNetError());
      if(BuildConfig.isDebug){
        Log.d('requestError', e.toString(),current: StackTrace.current);
      }

    }
  }
  
  Future<void>  requestLoadMore() async {
    try{
      var list = await requestListData();
      controller.loadComplete();
      if(list.isNotEmpty){
        page++;
        listItems.addAll(list);
        showContent();
        notifyListeners();
      }else{
        showToast("暂无更多数据");
      }
    }catch(e){
      controller.loadComplete();
      showToast(e.toNetError());
      if(BuildConfig.isDebug){
        Log.d('requestError', e.toString(),current: StackTrace.current);
      }
    }
  }
}