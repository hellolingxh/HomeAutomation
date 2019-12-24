
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class VoiceControl extends StatefulWidget {
  @override
  _VoiceControlState createState() => _VoiceControlState();
}

class _VoiceControlState extends State<VoiceControl> {
  
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = '';

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
      _speechRecognition = SpeechRecognition();
      _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
      );
      _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
      );
      _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech), 
      );
      _speechRecognition.setRecognitionCompleteHandler(
          () { 
              print('the result is : $resultText');
              setState(() => _isListening = false);
            }
      );
      _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
      );
  }
    
  @override
  Widget build(BuildContext context) {
    return Container(
            child: Column(
                children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            FloatingActionButton(
                                heroTag: 'test1',
                                mini: true,
                                backgroundColor:  Colors.deepOrange,
                                onPressed: () {
                                    if(_isListening)
                                        _speechRecognition.cancel().then(
                                            (result) => setState(() {
                                                _isListening = result;
                                                resultText = "";
                                            }),
                                        );
                                },
                                child: Icon(Icons.cancel),
                            ),
                            FloatingActionButton(
                                heroTag: 'test2',
                                child: Icon(Icons.mic),
                                onPressed: () {
                                    print('voice test 2 method. $_isAvailable and $_isListening');
                                    if(_isAvailable && !_isListening)
                                        _speechRecognition.listen(locale: 'en_US').then((result) => print('$result'));
                                },
                                backgroundColor: Colors.pink,
                            ),
                            FloatingActionButton(
                                heroTag: 'test3',
                                mini: true,
                                backgroundColor: Colors.deepPurple,
                                onPressed: () {
                                    if(_isListening)
                                        _speechRecognition.stop().then(
                                            (result) => setState(() => _isListening = result),
                                        );
                                },
                                child: Icon(Icons.stop),
                            ),
                        ]
                    ),
                    Container(
                        child: Text(resultText),
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                            color:  Colors.cyanAccent[100],
                            borderRadius:  BorderRadius.circular(6.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                        ),
                    ),
                    ]
            ),
    );
  }
}