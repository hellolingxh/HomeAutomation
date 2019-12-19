import 'package:flutter/material.dart';

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent,
);

class MyTileCard extends StatelessWidget {
  const MyTileCard(this.text, this.textStyle, this.action, this.backgroundColor, this.icon);
  
  final String text;
  final TextStyle textStyle;
  final Function action;
  final Color backgroundColor;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: new InkWell(
            onTap: () {navigate(context);},
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Text(text, style: textStyle,),
                        icon,
                    ],
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
                  child: action(),
              );
          }
      ));
  }

}