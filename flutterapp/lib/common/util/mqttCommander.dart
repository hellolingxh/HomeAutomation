import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';

/// 
/// This class encapsulate the MQTT Client that 
/// is implemented by the examples 
/// of official flutter mqtt client provided. 
/// 
class MqttCommander {

    String host; //MQTT Server Host Address

    int port; //MQTT Server Port

    String clientIdentifier; //MQTT Client Identifier

    bool secure; //established the connection with a scurity way.

    String username; // if secure is true then should given the username

    String password; // if secure is true then should given the password

    /// An annotated simple subscribe/publish usage example for mqtt_client. Please read in with reference
    /// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
    /// files for separate subscribe/publish tests.

    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    MqttClient client;

    MqttCommander(String remoteHost, int remotePort, String clientName, {bool isSecure:false, String username, String password}){
      host = remoteHost;
      port = remotePort;
      clientIdentifier = clientName;
      secure = isSecure;
      this.username = username;
      this.password = password;
      _connect();
    }

    _initial(){
      /// to create a mqtt client
      client = new MqttClient.withPort(host, clientIdentifier, port);

      /// Set logging on if needed, defaults to off
      client.logging(on: false);

      /// If you intend to use a keep alive value in your connect message that is not the default(60s)
      client.keepAlivePeriod = 20;

      /// Add the unsolicited disconnection callback
      client.onDisconnected = onDisconnected;

      /// Add the successful connection callback
      client.onConnected = onConnected;

      /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
      client.onSubscribed = onSubscribed;

      /// Set a ping received callback if needed, called whenever a ping response(pong) is received
      /// from the broker.
      client.pongCallback = pong;

      // Specific the definition protocol version.
      client.setProtocolV311();

      // The data transimission through the secure way.
      client.secure = secure;

      /// Create a connection message to use or use the default one. 
      /// the default keepalive interval(60s)
      final MqttConnectMessage connMess = MqttConnectMessage()
          .withClientIdentifier(clientIdentifier)
          .keepAliveFor(20) // Must agree with the keep alive set above or not set
          .withWillTopic('willtopic') // If you set this you must set a will message
          .withWillMessage('My Will message')
          .startClean() // Non persistent session for testing
          .withWillQos(MqttQos.atLeastOnce);
      print('Mosquitto client connecting....');
      client.connectionMessage = connMess;

    }

    Future _connect() async{

      /// to inital the context of the mqtt client
      _initial();

      /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
      /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
      /// never send malformed messages.
      try {
        if(secure)
          await client.connect(this.username, this.password);
        else
          await client.connect();
      } on Exception catch (e) {
        print('client exception - $e');
        client.disconnect();
      }

      /// Check we are connected
      if (client.connectionStatus.state == MqttConnectionState.connected) {
        print('Mosquitto client connected');
      } else {
        /// Use status here rather than state if you also want the broker return code.
        print(
            'ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
        client.disconnect();
      }

    }

    Future<int> _publish(final String topic, String message) async {

      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);

      /// Publish it
      print('Publishing our topic');
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);

      return 0;

    }

    disconnect() async{
      /// Wait for the unsubscribe message from the broker if you wish.
      await MqttUtilities.asyncSleep(2);
      print('Disconnecting');
      client.disconnect();
      return 0;
    }

    Future<int> _subscribe(String topic) async{
      await MqttUtilities.asyncSleep(2);
      client.subscribe(topic, MqttQos.atMostOnce);

      return 0;

    }

    Future<int> unsubscribe(String topic) async{
      /// Finally, unsubscribe and exit gracefully
      print('Unsubscribing');
      client.unsubscribe(topic);
      return 0;
    }

    /// The subscribed callback
    void onSubscribed(String topic) {
      print('Subscription confirmed for topic $topic');
    }

    /// The unsolicited disconnect callback
    void onDisconnected() {
      print('OnDisconnected client callback - Client disconnection');
      if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
        print('OnDisconnected callback is solicited, this is correct');
      }
    }

    /// The successful connect callback
    void onConnected() {
      print('OnConnected client callback - Client connection was sucessful');
    }

    /// Pong callback
    void pong() {
      print('Ping response client callback invoked');
    }

    ///To send the message according to the command which is a topic concept on MQTT.
    Future send(String command, String param) async{
      
      _publish(command, param);

    }

    ///To receive the message from broker according to the specific command which 
    ///is a topic concept on MQTT, then called the callback method passed by caller.
    Future receive(String command, Function(String) callback) async{
      
      _subscribe(command);

      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> list) { 

        final MqttPublishMessage receivedPayload = list[0].payload;
        final String message = MqttPublishPayload.bytesToStringAsString(receivedPayload.payload.message);

        print('notification: topic is <${list[0].topic}>, payload message is <-- $message -->');

        if(callback != null)
          callback(message);
      });
    }

}