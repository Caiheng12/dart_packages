part of batterylevel; 

class BatteryLevelViewController {
   StreamController _flutterToEvaluteStream;
   MethodChannel _battery_view_channel;
   EventChannel _battery_view_event_channel; 
   StreamSubscription _eventSinkStreamSubscription;
  
   BatteryLevelViewController({@required int viewId, StreamController flutterToEvaluteStream})
   : _battery_view_channel = MethodChannel("flutter.io/batterylevel_view_${viewId}"),
   _battery_view_event_channel = EventChannel("flutter.io/batterylevel_view_event_${viewId}"),
    _flutterToEvaluteStream = flutterToEvaluteStream; 

   Future<void> sendMessageToNatvie(String message) async{
     await _battery_view_channel.invokeMethod('nativeToEvalute', message);
     return Future.value();
   }

   void bindNativeMethodCallBackHandler() {
      _battery_view_channel.setMethodCallHandler(this._handler);
   }

   Future<dynamic> _handler(MethodCall call) async {
     switch (call.method) {
       case "flutterToEvalute":
       _flutterToEvaluteStream.sink.add(call.arguments);
        break;
       default:
        throw MissingPluginException();
       break;
     }
   }

   Future<void> listentNativeContinuesEvents() async {
     
     _eventSinkStreamSubscription = _battery_view_event_channel.receiveBroadcastStream("eventSink").cast<String>()
       .listen((data){
          _flutterToEvaluteStream.sink.add(data);
       });
       return Future.value();
   }
}