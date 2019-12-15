

import 'package:flutter/material.dart';
import '../../home/appHome.dart';

class GlobalConfig {

    static final String HTTP_PROTOCOL = "http://";

    static final String HTTPS_PROTOCOL = "https://";

    static final int PORT = 8080;

    static final Map<String, WidgetBuilder> ROUTES = {
        '/home': (_)=> new AppHome(),
    };

}