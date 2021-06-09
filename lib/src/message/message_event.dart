import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class SendMessageEvent{
   int msgCode;

   dynamic obj;

   SendMessageEvent(this.msgCode,{this.obj});

   void postMessage(){
     eventBus.fire(this);
   }
}