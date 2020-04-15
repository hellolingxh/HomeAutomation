import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';

class FanWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FanState();
    
}

class _FanState extends State<FanWidget> {

  final MqttCommander _commander = new MqttCommander(
    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
    GlobalConfig.MQTT_CLIENT_IDENTIFIER_FAN
  );
  
  bool _isRunning = false;
  int _speed = 70;

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
                title: Text("Fan Control Panel"),
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
      return new Container(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          Text('Fan Speed:'),
                          Text(_speed.toString()),
                      ],
                  ),
                  Slider(
                        value: _speed.toDouble(),
                        min: 0.0,
                        max: 100.0,
                        onChanged: (double value) {
                            print('on changed method, the value is '+value.toString());
                            setState(() {
                                _speed = value.round();
                            });
                            if(_isRunning)
                              _commander.send(Commands.FAN_CONTROL, _speed.toString());
                        },
                        onChangeStart: (double value){
                            print('on change start method, the value is '+value.toString());
                        },
                        onChangeEnd: (double value){
                            print('on change end method, the value is '+value.toString());
                        },
                    ),
                    Switch(
                        value: _isRunning,
                        onChanged: (bool value){
                            setState(() {
                                _isRunning = _isRunning ? false : true;
                            });                            
                            _commander.send(Commands.FAN_CONTROL, _isRunning ? _speed.toString() : 'off');
                        },
                    ),
              ],
          ),
      );
  }

}