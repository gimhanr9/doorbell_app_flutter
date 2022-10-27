import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/home_api.dart';
import 'package:flutter_doorbell/models/activity_log.dart';
import 'package:flutter_doorbell/screens/home/activity_details_screen.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/profile/profile_screen.dart';
import 'package:flutter_doorbell/screens/video_recording/recording_list_screen.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_doorbell/widgets/loaders/circular_loader.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeApiClient homeApiClient = HomeApiClient();
  late List activities;
  int numberOfActivities = 0;
  bool isLoading = false;
  bool isAuthenticated = true;
  bool noData = false;
  bool problem = false;
  String error = "";
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getActivityLog();
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
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff764abc)),
              accountName: Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: const FlutterLogo(),
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
                    builder: (BuildContext context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.cell_tower_rounded,
              ),
              title: const Text('Live'),
              onTap: () async {
                const url = 'https://blog.logrocket.com';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Cannot open the live streamer. Please try again later.'),
                    backgroundColor: Colors.red.shade300,
                  ));
                }
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
              onTap: () async {
                Navigator.pop(context);
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove('userToken');
                OneSignal.shared.removeExternalUserId();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              },
            ),
          ],
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
                      error: "No data available to display!", isLogin: true)
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Hi $username,",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "You've had $numberOfActivities visits",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
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

  void processData(Iterable list, userDetails) {
    List activityLog;
    activityLog = list.map((model) => ActivityLog.fromJson(model)).toList();
    setState(() {
      numberOfActivities = activities.length;
      activities = activityLog;
      isLoading = false;
      username = userDetails['name'];
      email = userDetails['email'];
    });
  }

  Future<void> getActivityLog() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('userToken');
    token ??= "";
    dynamic res = await homeApiClient.getActivityLog(token);

    if (res['error'] == null) {
      final response = res['data'];
      final userDetails = response['user_details'];
      if (res['data']['activities'].isNotEmpty) {
        List list = response['activities'];
        // processData(list);
        setState(() {
          activities = list;
          isLoading = false;
          numberOfActivities = list.length;
          username = userDetails['name'];
          email = userDetails['email'];
        });
      } else {
        setState(() {
          noData = true;
          isLoading = false;
          numberOfActivities = 0;
          username = userDetails['name'];
          email = userDetails['email'];
        });
      }

      //processData(list, userDetails);
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
                activityLog.imageUrl!,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        title: Text(
          activityLog.name!,
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
                  child: Text(activityLog.time! + " " + activityLog.date!,
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
                  builder: (context) => ActivityDetails(
                        name: activityLog.name!,
                        date: activityLog.date!,
                        time: activityLog.time!,
                        imageUrl: activityLog.imageUrl!,
                      )));
        },
      );
}
