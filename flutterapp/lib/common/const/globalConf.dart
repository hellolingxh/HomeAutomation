

import 'package:flutter/material.dart';

class GlobalConfig {

    static final ThemeData myTheme = new ThemeData(
      brightness: Brightness.light, 
      primarySwatch: Colors.teal, 
      accentColor: Colors.redAccent,
    );

    static const String CElSIUS_SYMBOL = '\u2103';

    static const String CCTV_VIDEO_STREAM_URL = 'http://192.168.8.133:8080/?action=stream';

    static const String DOOR_CAMERA_VIDEO_STREAM_URL = 'http://192.168.8.133:8088/?action=stream';

    static const String LOCAL_MQTT_BROKER_HOST = '192.168.8.1';

    static const int LOCAL_MQTT_BROKER_LISTEN_PORT = 1883;

    static const String AWS_ACTIVEMQ_HOST = 'b-ddb6ba7b-55f1-4ad2-b3c9-7754a11843ac-1.mq.eu-west-1.amazonaws.com';

    static const int AWS_ACTIVEMQ_LISTEN_PORT = 8883;

    static const String INDOOR = 'indoor';

    static const String OUTDOOR = 'outdoor';

    static const String SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_ON = 'light on';

    static const String SPEECH_RECOGNITION_KEY_WORD_TURN_LIGHT_OFF = 'light off';

    static const String DEFAULT_INITIAL_TEMPERATURE_VALUE = '17.8';

    static const String DEFAULT_INITIAL_HUMIDITY_VALUE = '43.7';

    static const String MQTT_CLIENT_IDENTIFIER_LIGHT = 'Light_MQTT_Client';

    static const String MQTT_CLIENT_IDENTIFIER_FAN = 'Fan_MQTT_Client';

    static const String MQTT_CLIENT_IDENTIFIER_SHUTTER = 'Shutter_MQTT_Client';

    static const String MQTT_CLIENT_IDENTIFIER_CCTV = 'CCTV_MQTT_Client';

    static const String MQTT_CLIENT_IDENTIFIER_ATMOSPHERE = 'Atmosphere_MQTT_Client';

    static const String MQTT_CLIENT_IDENTIFIER_DOORACCESS = 'DoorAccess_MQTT_Client';

}