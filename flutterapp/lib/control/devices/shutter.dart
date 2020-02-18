import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ShutterControlWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ShutterControlState();
}

class _ShutterControlState extends State {

  String shutterAction = "stop";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: new GlobalKey<ScaffoldState>(),
        appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("Shutter Control Panel"),
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
      return new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Slider(
                        value: 12,
                        min: 0.0,
                        max: 100.0,
                        onChanged: (double value) {
                            print('on changed method, the value is '+value.toString());
                            setState(() {
                                
                            });
                        },
                        onChangeStart: (double value){
                            print('on change start method, the value is '+value.toString());
                        },
                        onChangeEnd: (double value){
                            print('on change end method, the value is '+value.toString());
                        },
                    ),
                    ],
                ),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        IconButton(icon: new Icon(Icons.arrow_left, size: 48, color: Colors.blueAccent,), onPressed: (){
                            shutterAction = 'left';
                            print('shutter moves to left');
                            mqttConnect();
                        }),
                        IconButton(icon: new Icon(Icons.stop, size: 48, color: Colors.blueAccent,), onPressed: (){
                            shutterAction = 'stop';
                            print('shutter stop');
                            mqttConnect();
                        },),
                        IconButton(icon: new Icon(Icons.arrow_right, size: 48, color: Colors.blueAccent,), onPressed: (){
                            shutterAction = 'right';
                            print('shutter moves right');
                            mqttConnect();
                        },)
                    ],
                )
                
            ],
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

        client.setProtocolV311();

        /// Create a connection message to use or use the default one. The default one sets the
        /// client identifier, any supplied username/password, the default keepalive interval(60s)
        /// and clean session, an example of a specific one below.
        final MqttConnectMessage connMess = MqttConnectMessage()
            .withClientIdentifier('flutterapp')
            .keepAliveFor(20) // Must agree with the keep alive set above or not set
            .withWillTopic('willtopic') // If you set this you must set a will message
            .withWillMessage('My Will message')
            .startClean() // Non persistent session for testing
            //.authenticateAs('mqtt', '1qaz@WSX3edc')
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
        const String pubTopic = 'topic/shutter/control';
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        
        builder.addString(shutterAction);

        /// Subscribe to it
        print('EXAMPLE::Subscribing to the topic/light/control topic');
        client.subscribe(pubTopic, MqttQos.exactlyOnce);

        /// Publish it
        print('EXAMPLE::Publishing our topic');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);

        //await MqttUtilities.asyncSleep(1);
        setState(() {
             //notificate the flutter to refresh to component.
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


}