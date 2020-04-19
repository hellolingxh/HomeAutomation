import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/googleSpeechRecognition.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';
import 'package:flutterapp/home/appHome.dart';

class LightWidget extends StatefulWidget {
  final int networkType; // to decide the control through either WiFi or Internet

  LightWidget(this.networkType);

  @override
  State<StatefulWidget> createState() {
    _LightState _state ;
    
    if(networkType == 0)
      _state = new _LightState( new MqttCommander(
                    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
                    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
                    GlobalConfig.MQTT_CLIENT_IDENTIFIER_LIGHT
                    )
            );
    else
      _state = new _LightState( new MqttCommander(
                    GlobalConfig.AWS_ACTIVEMQ_HOST, 
                    GlobalConfig.AWS_ACTIVEMQ_LISTEN_PORT,
                    GlobalConfig.MQTT_CLIENT_IDENTIFIER_LIGHT,
                    isSecure: true,
                    username: GlobalConfig.AWS_ACTIVEMQ_USERNAME, 
                    password: GlobalConfig.AWS_ACTIVEMQ_PASSWORD
                  )
      );

      return _state;
  } 

}

class _LightState extends State<LightWidget> with GoogleSpeechRecognition{

  final MqttCommander _commander;

  bool _isLightOn = false;

  _LightState(this._commander);

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

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
                title: Text("Light Control Panel"),
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
      return new Container(
          child: new Center(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                            height: 260,
                            margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                            child: _isLightOn==false ? Icon(Icons.lightbulb_outline, size: 200,) :  Icon(Icons.lightbulb_outline, size: 200, color: Colors.deepOrangeAccent,),
                        ),
                        Switch(
                            value: _isLightOn,
                            onChanged: (bool value){
                                _commander.send(Commands.LIGHT_CONTROL, _isLightOn ? 'off' : 'on');
                                setState(() {
                                  _isLightOn = _isLightOn ? false : true; //notificate the flutter to refresh to component.
                                });
                            },
                        ),
                        FloatingActionButton(
                            heroTag: 'microphone',
                            child: Icon(Icons.mic),
                            onPressed: () {
                                if(isAvailable && !isListening)
                                    speechRecognition.listen(locale: 'en_US').then((result) => print('$result'));
                            },
                            backgroundColor: Colors.pink,
                        ),
                        isComplete ? Padding(child:Text(resultText,), padding: EdgeInsets.only(top: 5.0),) : Text(' '),
                ],
            ),
          ),
      );
  }

  @override
  void setAvailableState(bool result) {
    setState(() {
      isAvailable = result;
    });
  }

  @override
  void setRecognitionStartedState() {
    setState(() {
      isComplete = false;
      isListening = true;
    });
  }

  @override
  void setRecognitionResultState(String speech) {
    setState(() {
        resultText = speech;
    });
  }

  @override
  void activeCallback(bool result) {
    setState(() {
        isAvailable = result;
    });
  }

  @override
  void setRecognitionCompleteState() {
    setState(() {
      if(resultText==GlobalConfig.SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_ON)
        _isLightOn = true;
      else if(resultText==GlobalConfig.SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_OFF)
        _isLightOn = false;

      isListening = false;
      isComplete = true;
    });
    if(resultText==GlobalConfig.SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_ON || resultText==GlobalConfig.SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_OFF)
      _commander.send(Commands.LIGHT_CONTROL, _isLightOn ? 'on' : 'off');
  }

}
