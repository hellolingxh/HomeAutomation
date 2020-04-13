import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';

class ShutterControlWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ShutterControlState();
}

class _ShutterControlState extends State {

  final MqttCommander commander = new MqttCommander(
    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
    GlobalConfig.MQTT_CLIENT_IDENTIFIER_SHUTTER
  );

  String shutterAction = "stop";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Shutter Control Panel"),
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
      return new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        IconButton(icon: new Icon(Icons.arrow_left, size: 48, 
                            color: Colors.blueAccent,), 
                            onPressed: (){
                              shutterAction = 'left';
                              commander.send(Commands.SHUTTER_CONTROL, shutterAction);
                        }),
                        IconButton(icon: new Icon(Icons.stop, size: 48, 
                            color: Colors.blueAccent,), 
                            onPressed: (){
                              shutterAction = 'stop';
                              commander.send(Commands.SHUTTER_CONTROL, shutterAction);
                        },),
                        IconButton(icon: new Icon(Icons.arrow_right, size: 48, 
                            color: Colors.blueAccent,), 
                            onPressed: (){
                              shutterAction = 'right';
                              commander.send(Commands.SHUTTER_CONTROL, shutterAction);
                        },)
                    ],
                )
                
            ],
        ),
    );
  }

}