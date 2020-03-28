
import 'IBaseView.dart';

abstract class IBasePresenter<V extends IBaseView>{

  void attach(V view);

  void detach();
}