

import 'BaseModel.dart';
import 'IBasePresenter.dart';
import 'IBaseView.dart';

class BasePresenter<V extends IBaseView,M extends BaseModel> implements IBasePresenter{

   V _mProxyView;
   M _mModel;

   V getView() {
     return _mProxyView;
   }

    M getModel() {
     return _mModel;
   }


   @override
  void attach(IBaseView view) {
    _mProxyView = view;
    _mModel = new BaseModel() as M;
   }

  @override
  void detach() {
    _mProxyView = null;
  }

}