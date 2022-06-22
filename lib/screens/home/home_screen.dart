import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/meeting_api.dart';
import 'package:flutter_doorbell/models/meeting_details.dart';
import 'package:flutter_doorbell/screens/live_streaming/live_streaming_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: Center(
              child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: const Color(0xFF68C581),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LiveStreamingScreen()));
                },
                child: const Text(
                  "Live streaming",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]))),
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
}
