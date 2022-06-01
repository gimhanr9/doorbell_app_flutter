import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRenderer extends StatelessWidget {
  final _remoteVideoRenderer = RTCVideoRenderer();
  VideoRenderer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 210,
      child: Row(children: [
        Flexible(
          child: Container(
            key: Key('remote'),
            //margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: BoxDecoration(color: Colors.black),
            child: RTCVideoView(_remoteVideoRenderer),
          ),
        ),
      ]),
    );
  }
}
