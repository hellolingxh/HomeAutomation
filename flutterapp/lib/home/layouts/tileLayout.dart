import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/common/card/myTileCard.dart';
import 'package:flutterapp/common/card/myTileImageCart.dart';
import 'package:flutterapp/common/icon/flutter_custom_icon_icons.dart';
import 'package:flutterapp/control/deviceControlPanel.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);


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
    const _TileImageCard(),
    const MyTileImageCard('outdoor', 12, Colors.white, 'statics/images/outdoor.jpg', null,),
    const MyTileImageCard('indoor', 21, Colors.white, 'statics/images/indoor.jpg', null,),
    const MyTileCard(
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
    const MyTileCard(
            'Data Statistics',
            textStyle, 
            deviceControlPanelCallback,
            Colors.orange,
            Icon(
                Flutter_custom_icon.chart_line,
                size: 50,
                color: Colors.pink,
            )
        ),
    const MyTileCard(
            'Configuration', 
            textStyle, 
            deviceControlPanelCallback,
            Colors.cyan,
            Icon(
               Flutter_custom_icon.cog_alt,
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

class _TileImageCard extends StatelessWidget {

  const _TileImageCard();

  @override
  Widget build(BuildContext context) {
    
    return new Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero), side: BorderSide(width: 0, color: Colors.white)),
        child: Image.asset('statics/images/home_logo.jpg', fit: BoxFit.fill,),
    );
  }
    
}

class _TileCard extends StatelessWidget {
  const _TileCard(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return new Card(
        color: backgroundColor,
        child: new InkWell(
            onTap: () {navigate(context);},
            splashColor: colorScheme.onSurface.withOpacity(0.12),
            child: new Center(
                child: new Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Icon(
                        iconData,
                        color: Colors.red,
                    ),
                ),
            ),
        )
    );
  }

  void navigate(BuildContext context){
      Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context){
              return Theme(
                  data: _kTheme.copyWith(platform: Theme.of(context).platform),
                  child: DeviceControlPanel(),
              );
          }
      ));
  }
}