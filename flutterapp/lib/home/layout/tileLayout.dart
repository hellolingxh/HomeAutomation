import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/common/const/globalConf.dart';
import 'package:flutterapp/common/ui/tileCard.dart';
import 'package:flutterapp/common/icon/flutterCustomIcon.dart';
import 'package:flutterapp/control/deviceControlPanel.dart';

List<StaggeredTile> staggeredTiles = const <StaggeredTile>[
        const StaggeredTile.count(4, 3),
        const StaggeredTile.count(2, 3),
        const StaggeredTile.count(2, 2),
        const StaggeredTile.count(2, 1),
];

DeviceControlPanel deviceControlPanel() => DeviceControlPanel();

const textStyle = const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 20.0);

List<Widget> tiles = const <Widget> [
    const Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero), side: BorderSide(width: 0, color: Colors.white)),
        child: const Image(image: AssetImage(GlobalConfig.HOME_SCREEN_BACKGROUND_IMAGE), fit: BoxFit.fill,),
    ),
    const TileCard(
            'Remote Control', 
            textStyle, 
            deviceControlPanel,
            Colors.green,
            Icon(
                Icons.wifi,
                size: 50,
                color: Colors.white,
            )
        ),
    const TileCard(
            'Data Statistics',
            textStyle, 
            deviceControlPanel,
            Colors.orange,
            Icon(
                FlutterCustomIcon.chart_line,
                size: 50,
                color: Colors.pink,
            )
        ),
    const TileCard(
            'Configuration', 
            textStyle, 
            deviceControlPanel,
            Colors.cyan,
            Icon(
               FlutterCustomIcon.cog_alt,
                size: 50,
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
