import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/common/card/tileCard.dart';
import 'package:flutterapp/common/icon/flutterCustomIcon.dart';
import 'package:flutterapp/control/devices/cctv.dart';
import 'package:flutterapp/control/devices/fan.dart';
import 'package:flutterapp/control/devices/light_navigator.dart';
import 'package:flutterapp/control/devices/shutter.dart';

List<StaggeredTile> staggeredTiles = const <StaggeredTile>[
        const StaggeredTile.count(4, 2), // control panel picture
        const StaggeredTile.count(2, 2), // Camera control
        const StaggeredTile.count(2, 1), // Fan control
        const StaggeredTile.count(2, 1), // shutter control
        const StaggeredTile.count(1, 1), // indoor thermometer control
        const StaggeredTile.count(1, 1), // outdoor thermometer control
        const StaggeredTile.count(2, 3), // entertainment control
        const StaggeredTile.count(2, 1), // lighting control
        const StaggeredTile.count(2, 1), // door control
];

const textStyle = const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 20.0);
const smallTextStyle = const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w400, fontSize: 17.0);

CCTVWidget cctvWidgetCallback() => CCTVWidget();
LightNavigator lightWidgetCallback() => LightNavigator();
FanWidget fanWidgetCallback() => FanWidget();
ShutterControlWidget shutterControlWidgetCallback() => ShutterControlWidget();

List<Widget> tiles = const <Widget> [
    const _TileImageCard(),
    const TileCard(
            'CCTV', 
            textStyle, 
            cctvWidgetCallback,
            Colors.pinkAccent,
            Icon(
                FlutterCustomIcon.videocam,
                size: 50,
                color: Colors.white,
            )
         ),
    const TileCard(
            'Fan', 
            textStyle, 
            fanWidgetCallback,
            Colors.cyanAccent,
            Icon(
                Icons.device_hub,
                size: 30,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Shutter', 
            textStyle, 
            shutterControlWidgetCallback,
            Colors.green,
            Icon(
                Icons.shutter_speed,
                size: 30,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Outdoor', 
            smallTextStyle, 
            null,
            Colors.purpleAccent,
            Icon(
                FlutterCustomIcon.thermometer,
                size: 20,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Indoor', 
            smallTextStyle, 
            null,
            Colors.cyan,
            Icon(
                FlutterCustomIcon.thermometer,
                size: 20,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Entertainment', 
            textStyle, 
            null,
            Colors.greenAccent,
            Icon(
                FlutterCustomIcon.gamepad,
                size: 50,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Lighting', 
            textStyle, 
            lightWidgetCallback,
            Colors.lightBlue,
            Icon(
                FlutterCustomIcon.lamp,
                size: 30,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Door', 
            textStyle, 
            null,
            Colors.grey,
            Icon(
                FlutterCustomIcon.enter,
                size: 30,
                color: Colors.white,
            )
        ),
    
];

StaggeredGridView staggeredGridView = new StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: staggeredTiles,
                children: tiles,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                padding: const EdgeInsets.all(0.0),
);

class _TileImageCard extends StatelessWidget {

  const _TileImageCard();

  @override
  Widget build(BuildContext context) {
    
    return new Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero), side: BorderSide(width: 0, color: Colors.white)),
        child: Image.asset('statics/images/devices.png', fit: BoxFit.fill,),
    );
  }

}