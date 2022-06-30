import 'package:flutter/material.dart';
import 'package:flutter_doorbell/models/meeting_details.dart';
import 'package:flutter_doorbell/screens/home/home_screen.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/widgets/live_streaming/live_streamer.dart';
import 'package:flutter_doorbell/widgets/live_streaming/meeting_control_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveStreamingScreen extends StatefulWidget {
  //final MeetingDetail meetingDetail;

  const LiveStreamingScreen({
    Key? key,
    /*required this.meetingDetail*/
  }) : super(key: key);

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  final Map<String, dynamic> mediaConstraints = {"audio": true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: MeetingControlBar(
        onAudioToggle: onAudioToggle,
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void startMeeting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token;
    if (preferences.containsKey("userToken")) {
      token = preferences.getString("userToken");
      bool isTokenExpired = JwtDecoder.isExpired(token);
      if (!isTokenExpired) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        meetingHelper = WebRTCMeetingHelper(
            url: dotenv.env['NODE_API_URL'],
            meetingId: dotenv.env['MEETING_ID'] ?? 'f34569-324567',
            userId: decodedToken["userId"],
            name: decodedToken["name"]);

        MediaStream _localStream =
            await navigator.mediaDevices.getUserMedia(mediaConstraints);

        meetingHelper!.stream = _localStream;

        meetingHelper!.on(
          "open",
          context,
          (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          },
        );

        meetingHelper!.on(
          "connection",
          context,
          (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          },
        );

        meetingHelper!.on(
          "user-left",
          context,
          (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          },
        );

        meetingHelper!.on(
          "audio-toggle",
          context,
          (ev, context) {
            setState(() {});
          },
        );

        meetingHelper!.on(
          "meeting-ended",
          context,
          (ev, context) {
            onMeetingEnd();
          },
        );

        meetingHelper!.on(
          "connection-setting-changed",
          context,
          (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          },
        );

        meetingHelper!.on(
          "stream-changed",
          context,
          (ev, context) {
            setState(() {
              isConnectionFailed = false;
            });
          },
        );

        setState(() {});
      } else {
        goToLoginScreen();
      }
    } else {
      goToLoginScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomeScreen();
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: LiveStreamer(
                        renderer: meetingHelper!.connections[index].renderer,
                        connection: meetingHelper!.connections[index]),
                  );
                }),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Waiting for doorbell connection...",
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
      ],
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  void goToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void goToLoginScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
