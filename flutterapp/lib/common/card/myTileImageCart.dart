import 'package:flutter/material.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class MyTileImageCard extends StatelessWidget {
  const MyTileImageCard(this.text, this.thermometer, this.backgroundColor, this.assetImageName, this.action);
  
  final String text;
  final int thermometer;
  final Color backgroundColor;
  final String assetImageName;
  final Function action;

  @override
  Widget build(BuildContext context) {
    /*return new Card(
        color: backgroundColor,
        child: new InkWell(
            onTap: () { if(action != null) navigate(context);},
            child: new Center(
                child: new Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Opacity(
                        opacity: 0.60,
                        child: Image.asset(assetImageName, fit: BoxFit.cover, height: double.infinity, width: double.infinity, alignment: Alignment.center,),
                    ),
                ),
            ),
        )
    );*/

    return Card(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop),
            image: AssetImage(assetImageName),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
            children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 5.0, right: 5.0),
                    alignment: Alignment.topRight,
                    child: Text(text, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey, fontWeight: FontWeight.w500),),
                ),
                Container(
                    margin: EdgeInsets.only(top: 42.0, left: 5.0),
                    alignment: Alignment.bottomLeft,
                    child: Text(thermometer.toString()+'\u2103', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),),
                ),
            ],
        ),
      ),
    );
  }

  void navigate(BuildContext context){
      Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context){
              return Theme(
                  data: _kTheme.copyWith(platform: Theme.of(context).platform),
                  child: action(),
              );
          }
      ));
  }

}