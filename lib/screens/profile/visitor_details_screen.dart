import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/profile_api.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/profile/edit_visitor_screen.dart';
import 'package:flutter_doorbell/screens/profile/visitor_delete_selection_dialog.dart';
import 'package:flutter_doorbell/utils/color_file.dart';
import 'package:flutter_doorbell/widgets/loaders/circular_loader.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitorDetailsScreen extends StatefulWidget {
  final String fname;
  final String lname;
  final String imageUrl;
  final String id;

  const VisitorDetailsScreen(
      {Key? key,
      required this.fname,
      required this.lname,
      required this.imageUrl,
      required this.id})
      : super(key: key);

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  final ProfileApiClient profileApiClient = ProfileApiClient();
  bool isLoading = false;
  bool isAuthenticated = true;
  bool noData = false;
  bool problem = false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Visitor Details'),
        backgroundColor: ColorFile.header,
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
                            widget.fname + " " + widget.lname,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(widget.imageUrl),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 50.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EditVisitorScreen(
                                                  fname: widget.fname,
                                                  lname: widget.lname,
                                                  imageUrl: widget.imageUrl,
                                                )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: const Color(0xff0095FF),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Center(
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return VisitorDeleteSelectionDialog(
                                          selectYes: () {
                                            deleteVisitor(
                                                widget.id, widget.imageUrl);
                                          },
                                          selectNo: () {
                                            Navigator.pop(context);
                                          },
                                          visitorName:
                                              widget.fname + " " + widget.lname,
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Center(
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> deleteVisitor(String visitorId, String imageUrl) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('userToken');
    token ??= "";
    dynamic res =
        await profileApiClient.deleteVisitor(token, visitorId, imageUrl);

    if (res['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Visitor deleted successfully'),
        backgroundColor: Colors.green.shade400,
      ));
    } else {
      if (res['message'] == "Authentication failed") {
        setState(() {
          problem = true;
          error = res['message'];
          isAuthenticated = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  void sendToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ));
  }
}
