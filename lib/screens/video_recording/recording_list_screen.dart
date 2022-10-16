import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/recording_api.dart';
import 'package:flutter_doorbell/models/recording.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/video_recording/recording_player.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_doorbell/widgets/loaders/circular_loader.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingListScreen extends StatefulWidget {
  const RecordingListScreen({Key? key}) : super(key: key);

  @override
  State<RecordingListScreen> createState() => _RecordingListScreenState();
}

class _RecordingListScreenState extends State<RecordingListScreen> {
  final RecordingApiClient recordingApiClient = RecordingApiClient();
  late List recordings;
  bool isLoading = false;
  bool isAuthenticated = true;
  bool noData = false;
  bool problem = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    getRecordings();
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
      body: isLoading == true
          ? Center(
              child: CircularLoader(
                radius: 20.0,
                dotRadius: 5.0,
              ),
            )
          : problem == true
              ? NetworkCallInfo(
                  error: error,
                  isLogin: isAuthenticated,
                  onPressed: () {
                    sendToLogin();
                  },
                )
              : noData == true
                  ? const NetworkCallInfo(
                      error: "No data available to display!", isLogin: false)
                  : Container(
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

  void processData(Iterable list) {
    List recordingList;
    recordingList = list.map((model) => Recording.fromJson(model)).toList();
    setState(() {
      recordings = recordingList;
      isLoading = false;
    });
  }

  Future<void> getRecordings() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('userToken');
    token ??= "";
    dynamic res = await recordingApiClient.getRecordings(token);

    if (res['error'] == null) {
      Iterable list = json.decode(res['body']);
      processData(list);
    } else {
      setState(() {
        isLoading = false;
      });
      if (res['message'] == "Authentication failed") {
        setState(() {
          problem = true;
          error = res['message'];
          isAuthenticated = false;
        });
      } else {
        setState(() {
          problem = true;
          error = res['message'];
        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Error: ${res['message']}'),
        //   backgroundColor: Colors.red.shade300,
        // ));
      }
    }
  }

  void sendToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ));
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
          recording.name!,
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
                  child: Text(recording.date!,
                      style: const TextStyle(color: Colors.black))),
            )
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecordingPlayer(recordingUrl: recording.url!)));
        },
      );
}
