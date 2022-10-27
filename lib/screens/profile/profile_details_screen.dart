import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/profile_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/profile/edit_details_screen.dart';
import 'package:flutter_doorbell/widgets/loaders/circular_loader.dart';
import 'package:flutter_doorbell/widgets/loading_button/rounded_button.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final ProfileApiClient profileApiClient = ProfileApiClient();
  late List activities;
  bool isLoading = false;
  bool isAuthenticated = true;
  bool noData = false;
  bool problem = false;
  String error = "";
  String userName = "";
  String userEmail = "";
  ButtonState state = ButtonState.init;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Column(
                                        children: <Widget>[
                                          inputField("Email", userEmail),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          inputField("Name", userName),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 3, left: 3),
                                      width: 200,
                                      height: 60,
                                      child: CustomRoundedButton(
                                          enabled: true,
                                          text: "Edit",
                                          onPressed: () {
                                            sendToEdit();
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
    );
  }

  void sendToEdit() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => EditDetailsScreen(
        name: userName,
        email: userEmail,
      ),
    ));
  }

  void sendToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ));
  }

  Future<void> getProfileData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('userToken');
    token ??= "";
    dynamic res = await profileApiClient.getProfile(token);

    if (res['error'] == null) {
      Map<String, dynamic> user = res['data'];
      setState(() {
        isLoading = false;
        userName = user['name'];
        userEmail = user['email'];
      });
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

  Widget inputField(label, value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        Form(
          child: TextFormField(
            enabled: false,
            initialValue: value,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400))),
          ),
        ),
      ],
    );
  }
}
