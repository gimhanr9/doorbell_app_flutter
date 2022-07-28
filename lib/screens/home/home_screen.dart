import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/meeting_api.dart';
import 'package:flutter_doorbell/models/activity_log.dart';
import 'package:flutter_doorbell/models/meeting_details.dart';
import 'package:flutter_doorbell/screens/live_streaming/live_streaming_screen.dart';
import 'package:flutter_doorbell/screens/profile/add_visitor_screen.dart';
import 'package:flutter_doorbell/screens/profile/profile_screen.dart';
import 'package:flutter_doorbell/screens/video_recording/recording_list_screen.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List activities;

  @override
  void initState() {
    activities = getActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Home'),
        backgroundColor: ColorFile.header,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xff764abc)),
              accountName: Text(
                "Gimhan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "gimhanr9@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: FlutterLogo(),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_rounded,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person_rounded,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AddVisitorScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.cell_tower_rounded,
              ),
              title: const Text('Live'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const LiveStreamingScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.ondemand_video_rounded,
              ),
              title: const Text('Recordings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const RecordingListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) =>
                //         const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Hi Gimhan,",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "You've had 27 visits",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return makeCard(activities[index]);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("userToken");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    try {
      Response response =
          await joinMeeting(dotenv.env['MEETING_ID'] ?? 'f34569-324567');
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
    } catch (err) {
      var snackBar = const SnackBar(content: Text('Invalid meeting Id'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Card makeCard(ActivityLog activityLog) => Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(228, 247, 247, 247)),
          child: makeListCard(activityLog),
        ),
      );

  ListTile makeListCard(ActivityLog activityLog) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: SizedBox(
          height: 30,
          width: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://img.icons8.com/fluency/344/image.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        title: Text(
          activityLog.name ?? "Not Recognized",
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
                  child: Text(activityLog.date,
                      style: const TextStyle(color: Colors.black))),
            )
          ],
        ),
        trailing: const Icon(Icons.more_vert_rounded,
            color: Colors.black, size: 30.0),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             RecordingPlayer(recordingUrl: recording.url)));
        },
      );
}

List getActivities() {
  return [
    ActivityLog(
      name: "Tom",
      date: "29/06/2022",
      time: "10:59AM",
      imageurl: "",
    )
  ];
}
