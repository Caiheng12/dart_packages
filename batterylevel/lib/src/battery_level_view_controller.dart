part of batterylevel; 

class BatteryLevelViewController {
   
   MethodChannel _battery_view_channel;
  //  EventChannel _batter_view_event_channel;
   BatteryLevelViewController({@required int viewId})
   : _battery_view_channel = MethodChannel("flutter.io/batterylevel_view_${viewId}");
    // _batter_view_event_channel = EventChannel("flutter.io/batterylevel_view_event_%{viewId}");

   Future<void> sendMessageToNatvie(String message) async{
     await _battery_view_channel.invokeMethod('nativeToEvalute', message);
     return Future.value();
   }

   void bindNativeMethodCallBackHandler() {
      _battery_view_channel.setMethodCallHandler(this._handler);
   }

   void bindNativeBroadCastStreamHandler() {
    // _batter_view_event_channel.receiveBroadcastStream().listen(_handlerBroadcastStream);
   }

   Future<dynamic> _handler(MethodCall call) async {
     switch (call.method) {
       case "flutterToEvalute":
        break;
       default:
        throw MissingPluginException();
       break;
     }
   }

   void _handlerBroadcastStream(dynamic arguments ){

   }
}