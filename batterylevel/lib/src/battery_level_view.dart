
part of batterylevel; 


class BatterLevelView extends StatefulWidget {
  BatterLevelView({Key key}) : super(key: key);

  @override
  _BatterLevelViewState createState() => _BatterLevelViewState();
}

class _BatterLevelViewState extends State<BatterLevelView> {

  static  String  PLUGIN_PLAT_FORM_BASIC_VIEW_NAME =  "flutter.io/batterylevel_view";
  BatteryLevelViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('this is an natvive view'),
          // Container(height: 200, width: 300, color: Colors.grey,),
          Container(
            height: 600.0,
            width: 300.0,
            child:  _buildPlatformView(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
             Expanded(child: FlatButton(child: Text("send message from native", overflow: TextOverflow.fade, softWrap: true, textAlign: TextAlign.center,), onPressed: (){
               _controller.sendMessageToNatvie("message from flutter");
             },),),
             Expanded(child:  FlatButton(child: Text("recieve message from flutter", textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 4,), onPressed: (){
               _controller.bindNativeBroadCastStreamHandler();
             }),)
          ],)
        ],
      ) ,
    );
  }
  
  //Step1:创建对应的 PlatformView,AndroidView会根据对应的`viewType`去查找对应的 PlatformViewFactory,执行创建方法.
  Widget _buildPlatformView(BuildContext context){
      if (Platform.isAndroid) {
        return AndroidView(
          viewType: PLUGIN_PLAT_FORM_BASIC_VIEW_NAME,
          layoutDirection: TextDirection.ltr,
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          creationParams: "flutter call native platformViewFactory to create view and resen to flutter",
          onPlatformViewCreated: onPlatformViewCreated ,
          creationParamsCodec: StandardMessageCodec(),
        );
      } else if (Platform.isIOS) {
        return AndroidView(
          viewType: PLUGIN_PLAT_FORM_BASIC_VIEW_NAME,
          layoutDirection: TextDirection.ltr,
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          creationParams: "flutter call native platformViewFactory to create view and resen to flutter",
          onPlatformViewCreated: onPlatformViewCreated ,
          creationParamsCodec: StandardMessageCodec(),
        );
      } else {
        return Container();
        throw UnimplementedError("doew not support this platform view ");
      }
  }

  //Step2:当Native的视图创建完成后,会接到到`onPlatformViewCreated`的回调方法,根据对应的`viewId`生成methodChannel用于和当前生成的视图交互。
  void onPlatformViewCreated(int viewId) { 
     _controller = BatteryLevelViewController(viewId: viewId);
     _controller.bindNativeMethodCallBackHandler();
     _controller.bindNativeBroadCastStreamHandler();
  }

}