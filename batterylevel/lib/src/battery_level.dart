part of batterylevel; 

//无发再次导入其它文件,和 batterylevel中的import文件共享
class Batterylevel {

  static const MethodChannel _channel =
      const MethodChannel("flutter.io/batterylevel");


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> get getBatteryLevel async {
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
    return batteryLevel;
  }
}
