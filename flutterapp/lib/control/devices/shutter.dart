import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';
import 'package:flutterapp/home/appHome.dart';

class ShutterWidget extends StatefulWidget {

  final int networkType;  // to decide the control through either WiFi or Internet

  const ShutterWidget(this.networkType, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState(){
    _ShutterState _state ;
    
    if(networkType == 0)
      _state = new _ShutterState( new MqttCommander(
                    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
                    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
                    GlobalConfig.MQTT_CLIENT_IDENTIFIER_SHUTTER
                    )
            );
    else
      _state = new _ShutterState( new MqttCommander(
                    GlobalConfig.AWS_ACTIVEMQ_HOST, 
                    GlobalConfig.AWS_ACTIVEMQ_LISTEN_PORT,
                    GlobalConfig.MQTT_CLIENT_IDENTIFIER_SHUTTER,
                    isSecure: true,
                    username: GlobalConfig.AWS_ACTIVEMQ_USERNAME, 
                    password: GlobalConfig.AWS_ACTIVEMQ_PASSWORD
                  )
      );

      return _state;
  }
}

class _ShutterState extends State {

  final MqttCommander _commander;

  String _shutterAction = "stop";

  _ShutterState(this._commander);

  @override 
  void dispose() {
    super.dispose();
    _commander.disconnect();
  }

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
            onTap: (index) => Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context){
                  return Theme(
                      data: GlobalConfig.myTheme.copyWith(platform: Theme.of(context).platform),
                      child: AppHome(),
                  );
                }
            )),
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
                              _shutterAction = 'left';
                              _commander.send(Commands.SHUTTER_CONTROL, _shutterAction);
                        }),
                        IconButton(icon: new Icon(Icons.stop, size: 48, 
                            color: Colors.blueAccent,), 
                            onPressed: (){
                              _shutterAction = 'stop';
                              _commander.send(Commands.SHUTTER_CONTROL, _shutterAction);
                        },),
                        IconButton(icon: new Icon(Icons.arrow_right, size: 48, 
                            color: Colors.blueAccent,), 
                            onPressed: (){
                              _shutterAction = 'right';
                              _commander.send(Commands.SHUTTER_CONTROL, _shutterAction);
                        },)
                    ],
                )
                
            ],
        ),
    );
  }

}