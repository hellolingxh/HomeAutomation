import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/ui/tileCard.dart';
import 'package:flutterapp/common/icon/flutterCustomIcon.dart';
import 'package:flutterapp/control/devices/atmosphere.dart';
import 'package:flutterapp/control/devices/cctv.dart';
import 'package:flutterapp/control/devices/doorAccess.dart';
import 'package:flutterapp/control/option/entertainmentOption.dart';
import 'package:flutterapp/control/option/networksOption.dart';

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

CCTVWidget cctvWidget() => CCTVWidget();
NetworksOptionWidget lightWidget() => NetworksOptionWidget(deviceName: DEVICE_NAME.LIGHT);
NetworksOptionWidget fanWidget() => NetworksOptionWidget(deviceName:DEVICE_NAME.FAN);
NetworksOptionWidget shutterWidget() => NetworksOptionWidget(deviceName:DEVICE_NAME.SHUTTER);
AtmosphereWidget indoorAtmosphereWidget() => AtmosphereWidget(GlobalConfig.INDOOR);
AtmosphereWidget outdoorAtmosphereWidget() => AtmosphereWidget(GlobalConfig.OUTDOOR);
DoorAccessWidget doorAccessWidget() => DoorAccessWidget();
EntertainmentOptionWidget entertainmentOptionWidget() => EntertainmentOptionWidget();
List<Widget> tiles = const <Widget> [
    const Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero), side: BorderSide(width: 0, color: Colors.white)),
        child: const Image(image: AssetImage(GlobalConfig.DEVICE_CONTROL_PANEL_SCREEN_BACKGROUND_IMAGE), fit: BoxFit.fill,),
    ),
    const TileCard(
            'CCTV', 
            textStyle, 
            cctvWidget,
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
            fanWidget,
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
            shutterWidget,
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
            outdoorAtmosphereWidget,
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
            indoorAtmosphereWidget,
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
            entertainmentOptionWidget,
            Colors.greenAccent,
            Icon(
                FlutterCustomIcon.gamepad,
                size: 50,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Light', 
            textStyle, 
            lightWidget,
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
            doorAccessWidget,
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
