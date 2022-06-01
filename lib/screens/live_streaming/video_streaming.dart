import 'package:flutter/material.dart';
import 'package:flutter_doorbell/widgets/live_streaming/video_renderer.dart';

class VideoStreaming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Column(
          children: [
            VideoRenderer(),
          ],
        ));
  }
}
