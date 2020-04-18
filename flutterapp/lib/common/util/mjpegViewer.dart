import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:typed_data';
import 'dart:async';

/// 
/// This class encapsulate the feature that receive the video stream through http protocol. 
/// 
class MjpegView extends StatefulWidget {
  MjpegView({this.url, this.fps});

  final String url;
  final int fps;

  @override
  State<MjpegView> createState() => _MjpegViewState();
}

class _MjpegViewState extends State<MjpegView> {
  Image _mjpeg;
  var _imgBuf;
  Stopwatch _timer = Stopwatch();

  http.Client _client = http.Client();
  StreamSubscription videoStream;

  @override
  void initState() {
    super.initState();
    _buildImageStream();
  }

  void _buildImageStream() {
    
    var request = http.Request("GET", Uri.parse(widget.url));

    _client.send(request).then((response) {
      var startIndex = -1;
      var endIndex = -1;
      List<int> buf = List<int>();

      Duration ts;

      _timer.start();

      videoStream = response.stream.listen((List<int> data) {
        for (var i = 0; i < data.length - 1; i++) {
          if (data[i] == 0xff && data[i + 1] == 0xd8) {
            startIndex = buf.length + i;
          }

          if (data[i] == 0xff && data[i + 1] == 0xd9) {
            endIndex = buf.length + i;
          }
        }

        buf.addAll(data);

        if (startIndex != -1 && endIndex != -1) {
          // print('start $startIndex, end $endIndex');

          _timer.stop();
          ts = _timer.elapsed;

          if (ts.inMilliseconds > 1000 / widget.fps) {
            // print('duration ${ts.inMilliseconds / 1000}');

            _imgBuf = List<int>.from(buf.getRange(startIndex, endIndex + 2));
            _mjpeg = Image.memory(Uint8List.fromList(_imgBuf));

            precacheImage(_mjpeg.image, context);

            Future.delayed(const Duration(milliseconds: 100)).then((_) {
              if (mounted) setState(() {});
            });

            _timer.reset();
          }

          startIndex = endIndex = -1;
          buf = List<int>();
          _timer.start();
        }
      });
    });
  }

  @override
  void deactivate() {
    _timer?.stop();
    videoStream?.cancel();
    _client?.close();

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _mjpeg == null ? new Center(child: CircularProgressIndicator()) : _mjpeg;
}
    
}