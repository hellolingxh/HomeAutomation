import 'package:flutter/material.dart';
import 'package:flutterapp/common/const/globalConf.dart';

class ImageTileCard extends StatelessWidget {
  const ImageTileCard(this.text, this.thermometer, this.backgroundColor, this.assetImageName, this.action);
  
  final String text;
  final int thermometer;
  final Color backgroundColor;
  final String assetImageName;
  final Function action;

  @override
  Widget build(BuildContext context) {

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
                    child: Text(thermometer.toString()+GlobalConfig.CElSIUS_SYMBOL, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),),
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
                  data: GlobalConfig.myTheme.copyWith(platform: Theme.of(context).platform),
                  child: action(),
              );
          }
      ));
  }

}