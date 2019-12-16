import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

List<Widget> tiles = const <Widget> [
    const _TileImageCard(),
    const _TileCard(Colors.pinkAccent, Icons.info),
    const _TileCard(Colors.cyanAccent, Icons.photo),
    const _TileCard(Colors.green, Icons.widgets),
    const _TileCard(Colors.purpleAccent, Icons.photo_filter),
    const _TileCard(Colors.cyan, Icons.pie_chart),
    const _TileCard(Colors.lightBlue, Icons.wifi),
    const _TileCard(Colors.brown, Icons.map),
    const _TileCard(Colors.greenAccent, Icons.play_for_work),
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

class _TileCard extends StatelessWidget {
  const _TileCard(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
        color: backgroundColor,
        child: new InkWell(
            onTap: () { debugPrint('message test');},
            child: new Center(
                child: new Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: new Icon(
                        iconData,
                        color: Colors.white,
                    ),
                ),
            ),
        )
    );
  }

}