import 'package:flutter/material.dart';
import 'package:flutter_doorbell/models/recording.dart';
import 'package:flutter_doorbell/screens/video_recording/recording_player.dart';
import 'package:flutter_doorbell/utils/color_file.dart';

class RecordingListScreen extends StatefulWidget {
  const RecordingListScreen({Key? key}) : super(key: key);

  @override
  State<RecordingListScreen> createState() => _RecordingListScreenState();
}

class _RecordingListScreenState extends State<RecordingListScreen> {
  late List recordings;

  @override
  void initState() {
    recordings = getLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Recordings"),
        backgroundColor: ColorFile.header,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: recordings.length,
          itemBuilder: (context, index) {
            return makeCard(recordings[index]);
          },
        ),
      ),
    );
  }

  Card makeCard(Recording recording) => Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(228, 247, 247, 247)),
          child: makeListCard(recording),
        ),
      );

  ListTile makeListCard(Recording recording) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.play_arrow_rounded, color: Colors.black),
            ],
          ),
        ),
        title: Text(
          recording.name,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(recording.date,
                      style: const TextStyle(color: Colors.black))),
            )
          ],
        ),
        trailing: const Icon(Icons.more_vert_rounded,
            color: Colors.black, size: 30.0),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecordingPlayer(recordingUrl: recording.url)));
        },
      );
}

List getLessons() {
  return [
    Recording(
      name: "Sample Video",
      date: "29/06/2022",
      url: "https://www.youtube.com/watch?v=tXVNS-V39A0",
    )
  ];
}
