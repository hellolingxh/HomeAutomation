import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/control/devices/fan.dart';
import 'package:flutterapp/control/devices/light.dart';
import 'package:flutterapp/control/devices/shutter.dart';

class NetworksOptionWidget extends StatefulWidget {

  final DEVICE_NAME deviceName;

  const NetworksOptionWidget({Key key, @required this.deviceName}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => new _NetworksOptionState();

}

class _NetworksOptionState extends State<NetworksOptionWidget> {
  
  int radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Network Options"),
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

  
  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }
  
  Widget _buildBody(){
      return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Radio<int>(
                      value: 0,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged,
                    ),
                    new Text(GlobalConfig.NETWORK_OPTION_WIFI,style: new TextStyle(fontSize: 16.0)),
                    Radio<int>(
                      value: 1,
                      groupValue: radioValue,
                      onChanged: handleRadioValueChanged,
                    ),
                    new Text(GlobalConfig.NETWORK_OPTION_INTERNET, style: new TextStyle(fontSize: 16.0,)),
                ],
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        child: Text('Next', style: new TextStyle(fontSize: 16.0)),
                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute<void>(
                                builder: (BuildContext context){
                                    return Theme(
                                        data: GlobalConfig.myTheme.copyWith(platform: Theme.of(context).platform),
                                        child: _findWidget(this.widget.deviceName),
                                    );
                                }
                            ));
                        },
                    ),
                ],
            ),
        ]
      )
    );
  }

  Widget _findWidget(DEVICE_NAME deviceName){

    Widget widget;

    switch(deviceName){
      case DEVICE_NAME.LIGHT:
        widget = new LightWidget(radioValue);
        break;
        
      case DEVICE_NAME.FAN:
        widget = new FanWidget(radioValue);
        break;

      case DEVICE_NAME.SHUTTER:
        widget = new ShutterWidget(radioValue);
        break;

      default:
        break;

    }

    return widget;
  }
    
}