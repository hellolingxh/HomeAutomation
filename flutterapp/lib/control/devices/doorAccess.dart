
import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/mjpegViewer.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';

class DoorAccessWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoorAccessState();

}

class _DoorAccessState extends State<StatefulWidget> {

  final MqttCommander _commander = new MqttCommander(
    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
    GlobalConfig.MQTT_CLIENT_IDENTIFIER_DOORACCESS
  );

  bool _isVideoLoading = false;
  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      ///to notify the door camera to turn on.
      _commander.send(Commands.DOOR_CAMERA_CONTROL, "on");
    });
    
  }

  @override
  void dispose(){
    super.dispose();
    _isVideoLoading = false;
    _commander.send(Commands.DOOR_CAMERA_CONTROL, "off");
    _commander.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Door Access Control Panel"),
                elevation: 10.0,
                centerTitle: true,
                backgroundColor: Colors.teal,
        ),
        body: new Padding(
            padding: const EdgeInsets.all(0.0),
            child: _buildBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0, // This will be set when a new tab is tapped
            backgroundColor: Colors.teal,
            items: [
                BottomNavigationBarItem(
                    icon: new Icon(Icons.home, color: Colors.white,),
                    title: new Text('Home', style: TextStyle(color: Colors.white),),
                ),
                BottomNavigationBarItem(
                    icon: new Icon(Icons.account_circle, color: Colors.white),
                    title: new Text('Me', style: TextStyle(color: Colors.white),),
                )
            ],
        ),
    );
  }

  Widget _buildBody(){
      /// To notifiy the UI engine to re-render.
      _updateVideoState();

      return new Container(
          child: new Center(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        new Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                                    height: 260,
                                    margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                                    alignment: Alignment.topRight,
                                    child: !_isVideoLoading ? 
                                          Center(child: CircularProgressIndicator()) :  
                                          MjpegView(url: 'http://192.168.8.133:8088/?action=stream', fps: 200),
                                ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                lockButtonWidget(),
                                
                            ],
                        ),
                        
                ],
            ),
          ),
      );
  }


  Widget lockButtonWidget (){
      return IconButton(
                icon: Icon(((_isLocked) ? Icons.lock: Icons.lock_open), size:40,),
                onPressed: () {
                    setState(() {
                        _isLocked = _isLocked ? false : true;
                    });
                    
                    _commander.send(Commands.DOOR_LOCKER_CONTROL, _isLocked ? "lock" : "unlock");
                    
                },
                color: Colors.blue,
            );
  }

  void _updateVideoState() async {
    //when the command has already sent to CCTV, then will get the live video after 3 seconds.
    await Future.delayed(const Duration(milliseconds: 2500), () {
      if(!_isVideoLoading){
        setState(() {
          _isVideoLoading = true; //notificate the flutter to refresh to component.
        });
      }
      
    });
    
  }


}