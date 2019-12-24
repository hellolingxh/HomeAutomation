
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:speech_recognition/speech_recognition.dart';

class LightWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LightState();

}

class _LightState extends State<LightWidget> {
  
  bool isLightOn = false;

  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  bool _isComplete = false;

  String resultText = '';

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Lights Control Panel"),
                elevation: 10.0,
                centerTitle: true,
                backgroundColor: Colors.teal,
        ),
        body: new Padding(
            padding: const EdgeInsets.all(0.0),
            child: _buildBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0, // This will be set when a new tab is tapped
            backgroundColor: Colors.teal,
            items: [
                BottomNavigationBarItem(
                    icon: new Icon(Icons.home, color: Colors.white,),
                    title: new Text('Home', style: TextStyle(color: Colors.white),),
                ),
                BottomNavigationBarItem(
                    icon: new Icon(Icons.account_circle, color: Colors.white),
                    title: new Text('Me', style: TextStyle(color: Colors.white),),
                )
            ],
        ),
    );
  }

  Widget _buildBody(){
      return new Container(
          child: new Center(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                            height: 260,
                            margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                            child: isLightOn==false ? Icon(Icons.lightbulb_outline, size: 200,) :  Icon(Icons.lightbulb_outline, size: 200, color: Colors.deepOrangeAccent,),
                        ),
                        Switch(
                            value: isLightOn,
                            onChanged: (bool value){
                                isLightOn = isLightOn ? false : true;
                                print('test lighting button, isLoading is ' + isLightOn.toString());
                                
                                mqttConnect();
                            },
                        ),
                        FloatingActionButton(
                            heroTag: 'microphone',
                            child: Icon(Icons.mic),
                            onPressed: () {
                                print('voice test 2 method. $_isAvailable and $_isListening');
                                if(_isAvailable && !_isListening)
                                    _speechRecognition.listen(locale: 'en_US').then((result) => print('$result'));
                            },
                            backgroundColor: Colors.pink,
                        ),
                        _isComplete ? Padding(child:Text(resultText,), padding: EdgeInsets.only(top: 5.0),) : Text(' '),
                ],
            ),
          ),
      );
  }

  final MqttClient client = MqttClient('192.168.8.1', '');

  Future<int> mqttConnect() async{

    client.logging(on: false);

  /// If you intend to use a keep alive value in your connect message that is not the default(60s)
  /// you must set it here
  client.keepAlivePeriod = 20;

  /// Add the unsolicited disconnection callback
  client.onDisconnected = onDisconnected;

  /// Add the successful connection callback
  client.onConnected = onConnected;

  /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
  /// You can add these before connection or change them dynamically after connection if
  /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
  /// can fail either because you have tried to subscribe to an invalid topic or the broker
  /// rejects the subscribe request.
  client.onSubscribed = onSubscribed;

  /// Set a ping received callback if needed, called whenever a ping response(pong) is received
  /// from the broker.
  client.pongCallback = pong;

  /// Create a connection message to use or use the default one. The default one sets the
  /// client identifier, any supplied username/password, the default keepalive interval(60s)
  /// and clean session, an example of a specific one below.
  final MqttConnectMessage connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .keepAliveFor(20) // Must agree with the keep alive set above or not set
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
  /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
  /// never send malformed messages.
  try {
    await client.connect();
  } on Exception catch (e) {
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus.state == MqttConnectionState.connected) {
    print('EXAMPLE::Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }

  /// Ok, lets try a subscription
  print('EXAMPLE::Subscribing to the topic/test topic');
  const String topic = 'topic/test'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage recMess = c[0].payload;
    final String pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  client.published.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
  });

  /// Lets publish to our topic
  /// Use the payload builder rather than a raw buffer
  /// Our known topic to publish to
  const String pubTopic = 'topic/light/control';
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(isLightOn ? 'on' : 'off');

  /// Subscribe to it
  print('EXAMPLE::Subscribing to the topic/light/control topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// Publish it
  print('EXAMPLE::Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);

  //await MqttUtilities.asyncSleep(1);
  setState(() {
      isLightOn = isLightOn; //notificate the flutter to refresh to component.
  });

  /// Ok, we will now sleep a while, in this gap you will see ping request/response
  /// messages being exchanged by the keep alive mechanism.
  print('EXAMPLE::Sleeping....');
  await MqttUtilities.asyncSleep(120);

  /// Finally, unsubscribe and exit gracefully
  print('EXAMPLE::Unsubscribing');
  //client.unsubscribe(topic);

  /// Wait for the unsubscribe message from the broker if you wish.
  await MqttUtilities.asyncSleep(2);
  print('EXAMPLE::Disconnecting');
  client.disconnect();
  return 0;
  }

/// The subscribed callback
void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
    print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  }
}

/// The successful connect callback
void onConnected() {
  print('EXAMPLE::OnConnected client callback - Client connection was sucessful');
}

/// Pong callback
void pong() {
  print('EXAMPLE::Ping response client callback invoked');
}


void initSpeechRecognizer(){
      _speechRecognition = SpeechRecognition();
      _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() {
              _isAvailable = result;
           }),
      );
      _speechRecognition.setRecognitionStartedHandler(
          () => setState(() {
              _isComplete = false;
              _isListening = true;
            }),
      );
      _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() {
              resultText = speech;
          }), 
      );
      _speechRecognition.setRecognitionCompleteHandler(
          () { 
              print('the result is : $resultText');
            
              setState(() {
                  if(resultText=='light on')
                    isLightOn = true;
                  else if(resultText=='light off')
                    isLightOn = false;

                  _isListening = false;
                  _isComplete = true;
              });
              if(resultText=='light on' || resultText=='light off')
                mqttConnect();
            }
      );
      _speechRecognition.activate().then(
          (result) => setState(() {
              _isAvailable = result;
          }),
      );
  }

}
