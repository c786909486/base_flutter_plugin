import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class MessageEvent{
   int msgCode;

   dynamic obj;

   MessageEvent(this.msgCode);

   void postMessage(){
     eventBus.fire(this);
   }
}