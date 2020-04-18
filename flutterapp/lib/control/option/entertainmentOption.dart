
import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/home/appHome.dart';

class EntertainmentOptionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EntertainmentOptionState();

}

class _EntertainmentOptionState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Game Options"),
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
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:3.0),
              child: Icon(
                Icons.adjust,
                size: 60,
                color: Colors.red[300],
                ),
            ),
          ],),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom:38.0),
              child: Text("Bomb Man", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            ),
          ],),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:3.0),
              child: Icon(
                Icons.sort_by_alpha,
                size: 60,
                color:Colors.cyan,),
            ),
          ],),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom:38.0),
              child: Text("Word Game", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
            ),
          ],),
        ],
      );
    }

}