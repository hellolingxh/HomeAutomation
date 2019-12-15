import 'package:flutter/material.dart';
import '../common/const/globalConf.dart';
import 'appHome.dart';


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
    
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        title: 'My Home Automation',
        color: Colors.grey,
        home: AppHome(),
        routes: GlobalConfig.ROUTES
    );

  }

}