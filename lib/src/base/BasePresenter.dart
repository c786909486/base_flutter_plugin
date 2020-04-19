

import 'BaseModel.dart';
import 'IBasePresenter.dart';
import 'IBaseView.dart';

abstract class BasePresenter<V extends IBaseView,M extends BaseModel> implements IBasePresenter{

   V _mProxyView;
   M _mModel;

   V getView() {
     return _mProxyView;
   }

    M getModel() {
     if(_mModel==null){
       _mModel = createModel();
     }
     return _mModel;
   }


   @override
  void attach(IBaseView view) {
    _mProxyView = view;
   }

   M createModel();

  @override
  void detach() {
    _mProxyView = null;
  }


}