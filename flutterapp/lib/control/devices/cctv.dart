import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/commands.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/util/mjpegViewer.dart';
import 'package:flutterapp/common/util/mqttCommander.dart';
import 'package:flutterapp/home/appHome.dart';

class CCTVWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _CCTVState();

}

class _CCTVState extends State<CCTVWidget> {

  final MqttCommander _commander = new MqttCommander(
    GlobalConfig.LOCAL_MQTT_BROKER_HOST, 
    GlobalConfig.LOCAL_MQTT_BROKER_LISTEN_PORT,
    GlobalConfig.MQTT_CLIENT_IDENTIFIER_CCTV
  );

  bool _isVideoLoading = false;

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
                title: Text("CCTV Control Panel"),
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
                        new Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                                    height: 260,
                                    margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                                    alignment: Alignment.topRight,
                                    child: _isVideoLoading==false ? 
                                          Center(child: CircularProgressIndicator()) :  
                                          MjpegView(url: GlobalConfig.CCTV_VIDEO_STREAM_URL, fps: 100),
                                    ),
                        ),
                        IconButton(
                            icon: Icon(Icons.videocam, size:40,),
                            onPressed: () {
                                _commander.send(Commands.CCTV_CONTROL, _isVideoLoading ? 'off' : 'on');
                                _updateVideoState();
                            },
                            color: _isVideoLoading == false ? Colors.grey : Colors.blue,
                        ),
                ],
            ),
          ),
      );
  }

  void _updateVideoState() async {
    //when the command has already sent to CCTV, then will get the live video after 3 seconds.
    await Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _isVideoLoading = _isVideoLoading ? false : true; //notificate the flutter to refresh to component.
      });
    });
    
  }
  
}