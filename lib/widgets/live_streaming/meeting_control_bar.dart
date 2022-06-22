import 'package:flutter/material.dart';

class MeetingControlBar extends StatelessWidget {
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  MeetingControlBar(
      {this.audioEnabled,
      this.onAudioToggle,
      this.isConnectionFailed,
      this.onMeetingEnd,
      this.onReconnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
            onPressed: onAudioToggle,
            icon: Icon(audioEnabled! ? Icons.mic : Icons.mic_off),
            color: Colors.white,
            iconSize: 32.0),
        const SizedBox(width: 25.0),
        Container(
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
          child: IconButton(
              onPressed: onMeetingEnd,
              icon: const Icon(Icons.call_end, color: Colors.white)),
        )
      ];
    } else {
      return <Widget>[
        Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
          child: (TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: onReconnect!,
            child: const Text(
              "Reconnect",
              style: TextStyle(color: Colors.white),
            ),
          )),
        )
      ];
    }
  }
}
