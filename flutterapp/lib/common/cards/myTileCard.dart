import 'package:flutter/material.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class ImageStyle {
    double height;
    double widht;
    Alignment aligment;

    ImageStyle(this.height, this.widht, this.aligment);
}

class MyTileCard extends StatelessWidget {
  const MyTileCard(this.text, this.textStyle, this.action, this.backgroundColor, this.assetImageName, this.imageStyle);
  
  final String text;
  final TextStyle textStyle;
  final Function action;
  final Color backgroundColor;
  final String assetImageName;
  final ImageStyle imageStyle;
  
  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Column(
            children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 5.0, right: 5.0),
                    alignment: Alignment.center,
                    child: Text(text, style: textStyle,),
                ),
                Container(
                    margin: EdgeInsets.only(top: 42.0, left: 5.0),
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(assetImageName, height: imageStyle.height, width: imageStyle.widht, alignment: imageStyle.aligment,),
                ),
            ],
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