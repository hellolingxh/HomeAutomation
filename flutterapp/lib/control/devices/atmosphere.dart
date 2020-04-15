
import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/icon/flutterCustomIcon.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';
import 'package:mqtt_client/mqtt_client.dart';

class AtmosphereWidget extends StatefulWidget {
  
  /// to decide the temperature and humidity measurement in which environment.
  final String indoorOrOutdoor;

  const AtmosphereWidget(this.indoorOrOutdoor, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AtmosphereState();

}

class _AtmosphereState extends State<AtmosphereWidget> {
  
  final MqttCommander _commander = new MqttCommander(
    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
    GlobalConfig.MQTT_CLIENT_IDENTIFIER_ATMOSPHERE
  );

  String _thermometerValue = GlobalConfig.DEFAULT_INITIAL_TEMPERATURE_VALUE;
  String _humidityValue = GlobalConfig.DEFAULT_INITIAL_HUMIDITY_VALUE;

  bool _isPublishing;

  final int intervalSeconds = 1;

  @override
  void initState() {
    super.initState();
    _isPublishing = true;
    // notify the device to send the measurement data to mobile app interval.
    publishInterval(intervalSeconds);
  }

  @override
  void dispose(){
    super.dispose();
    _isPublishing = false;
    _commander.unsubscribe(
      widget.indoorOrOutdoor == GlobalConfig.INDOOR ? 
        Commands.INDOOR_TEMPERATURE_HUMIDITY_DATA_RECEIVE :
        Commands.OUTDOOR_TEMPERATURE_HUMIDITY_DATA_RECEIVE
      );
    _commander.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    
    _commander.receive(
      widget.indoorOrOutdoor == GlobalConfig.INDOOR ?
        Commands.INDOOR_TEMPERATURE_HUMIDITY_DATA_RECEIVE :
        Commands.OUTDOOR_TEMPERATURE_HUMIDITY_DATA_RECEIVE,
      refreshMeasurement);
    
    return new Scaffold(
            key: new GlobalKey<ScaffoldState>(),
            appBar: AppBar(
                    automaticallyImplyLeading: true,
                    title: Text(
                      widget.indoorOrOutdoor == GlobalConfig.INDOOR ? 
                        "Indoor Atmosphere Panel" : 
                        "Oudoor Atmosphere Panel"
                      ),
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
          child: new Center(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(30.0),
                            child: Text("Thermometer"),
                        ),
                        Icon(FlutterCustomIcon.thermometer, size: 60, color: Colors.orangeAccent,),
                        Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 15.0, bottom: 3.0),
                            child: Text(_thermometerValue+GlobalConfig.CElSIUS_SYMBOL),
                        ),
                        Container(
                            margin: EdgeInsets.all(30.0),
                            child: Text("Humidity"),
                        ),
                        Icon(FlutterCustomIcon.cog_alt, size: 60, color: Colors.orangeAccent),
                        Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 15.0, bottom: 3.0),
                            child: Text(_humidityValue+"%"),
                        ),
                        
                ],
            ),
          ),
      );
    }

    Future publishInterval(int second) async{
      
      while (_isPublishing){
        /// Publish the message to the topic
        _commander.send(
          widget.indoorOrOutdoor == GlobalConfig.INDOOR ?
            Commands.INDOOR_TEMPERATURE_HUMIDITY_DATA_READ:
            Commands.OUTDOOR_TEMPERATURE_HUMIDITY_DATA_READ,
            'on'
        );
        await MqttUtilities.asyncSleep(second);
      }
    }
    // This is a callback method that is called when the message has already received. 
    void refreshMeasurement(String message){
      if(message.contains("|")){
        List<String> result = message.split("|");
        setState(() {
         _thermometerValue = result[0];
         _humidityValue = result[1];
        });
        
      }
    
    }

}