import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/common/ui/imageTileCart.dart';
import 'package:flutterapp/common/ui/tileCard.dart';
import 'package:flutterapp/common/icon/flutterCustomIcon.dart';
import 'package:flutterapp/control/deviceControlPanel.dart';

List<StaggeredTile> staggeredTiles = const <StaggeredTile>[
        const StaggeredTile.count(4, 2),
        const StaggeredTile.count(2, 1),
        const StaggeredTile.count(2, 1),
        const StaggeredTile.count(2, 3),
        const StaggeredTile.count(2, 2),
        const StaggeredTile.count(2, 1),
];

DeviceControlPanel deviceControlPanelCallback() => DeviceControlPanel();

const textStyle = const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 20.0);

List<Widget> tiles = const <Widget> [
    const _HomeLogoCard(),
    const ImageTileCard('outdoor', 12, Colors.white, 'statics/images/outdoor.jpg', null,),
    const ImageTileCard('indoor', 21, Colors.white, 'statics/images/indoor.jpg', null,),
    const TileCard(
            'Remote Control', 
            textStyle, 
            deviceControlPanelCallback,
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
            deviceControlPanelCallback,
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
            deviceControlPanelCallback,
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

class _HomeLogoCard extends StatelessWidget {

  const _HomeLogoCard();

  @override
  Widget build(BuildContext context) {
    
    return new Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero), side: BorderSide(width: 0, color: Colors.white)),
        child: Image.asset('statics/images/home_logo.jpg', fit: BoxFit.fill,),
    );
  }
    
}