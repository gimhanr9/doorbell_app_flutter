import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class LiveStreamer extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final Connection connection;
  LiveStreamer({required this.renderer, required this.connection});

  @override
  State<LiveStreamer> createState() => _LiveStreamerState();
}

class _LiveStreamerState extends State<LiveStreamer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: RTCVideoView(
            widget.renderer,
            mirror: false,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        Container(
          color: Colors.transparent,
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          bottom: 10.0,
          left: 10,
        ),
      ],
    );
  }
}
