import 'package:flutter/material.dart';
import 'package:flutterapp/control/devices/light.dart';
import 'package:flutterapp/control/devices/light_with_internet.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class LightNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LightNavigator();

}

class _LightNavigator extends State<LightNavigator> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Lights Control Panel Options"),
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

  int radioValue = 0;
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
                    new Text(
                            'WIFI',
                            style: new TextStyle(
                                fontSize: 16.0,
                            ),
                    ),
                    Radio<int>(
                    value: 1,
                    groupValue: radioValue,
                    onChanged: handleRadioValueChanged,
                    ),
                    new Text(
                            'INTERNET',
                            style: new TextStyle(
                                fontSize: 16.0,
                            ),
                    ),
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
                        child: Text(
                            'Next',
                            style: new TextStyle(
                                fontSize: 16.0,
                            ),),
                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute<void>(
                                builder: (BuildContext context){
                                    return Theme(
                                        data: _kTheme.copyWith(platform: Theme.of(context).platform),
                                        child: radioValue == 1 ? new LightWithInternetWidget() : new LightWidget(),
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
    
}