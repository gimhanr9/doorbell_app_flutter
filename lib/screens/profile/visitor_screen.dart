import 'package:flutter/material.dart';
import 'package:flutter_doorbell/api/profile_api.dart';
import 'package:flutter_doorbell/models/saved_visitor.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/screens/profile/add_visitor_screen.dart';
import 'package:flutter_doorbell/screens/profile/edit_visitor_screen.dart';
import 'package:flutter_doorbell/screens/profile/visitor_delete_selection_dialog.dart';
import 'package:flutter_doorbell/screens/profile/visitor_details_screen.dart';
import 'package:flutter_doorbell/widgets/loaders/circular_loader.dart';
import 'package:flutter_doorbell/widgets/network_call_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({Key? key}) : super(key: key);

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  final ProfileApiClient profileApiClient = ProfileApiClient();
  late List visitors;
  bool isLoading = false;
  bool isAuthenticated = true;
  bool noData = false;
  bool problem = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    getVisitors();
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
                      error: "No data available to display!", isLogin: true)
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          const SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: visitors.length,
                                  itemBuilder: (context, index) {
                                    return makeCard(visitors[index]);
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const AddVisitorScreen(),
          ));
        },
      ),
    );
  }

  void processData(Iterable list) {
    List savedVisitors;
    savedVisitors = list.map((model) => SavedVisitor.fromJson(model)).toList();
    setState(() {
      visitors = savedVisitors;
      isLoading = false;
    });
  }

  Future<void> getVisitors() async {
    if (mounted) {
      if (isLoading == false) {
        setState(() {
          isLoading = true;
        });
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('userToken');
      token ??= "";
      dynamic res = await profileApiClient.getVisitors(token);

      if (res['error'] == null) {
        //processData(list);
        if (res['data'].isNotEmpty) {
          List list = res['data'];
          // processData(list);
          setState(() {
            visitors = list;
            isLoading = false;
          });
        } else {
          setState(() {
            noData = true;
            isLoading = false;
          });
        }
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
      getVisitors();
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

  Card makeCard(SavedVisitor savedVisitor) => Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(228, 247, 247, 247)),
          child: makeListCard(savedVisitor),
        ),
      );

  ListTile makeListCard(SavedVisitor savedVisitor) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.white24))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                savedVisitor.imageUrl!,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        title: Text(
          savedVisitor.fname! + " " + savedVisitor.lname!,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              )
            ];
          },
          onSelected: (String value) {
            if (value == 'edit') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => EditVisitorScreen(
                        fname: savedVisitor.fname!,
                        lname: savedVisitor.lname!,
                        imageUrl: savedVisitor.imageUrl!,
                      )));
            } else if (value == 'delete') {
              showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return VisitorDeleteSelectionDialog(
                    selectYes: () {
                      deleteVisitor(savedVisitor.id!, savedVisitor.imageUrl!);
                    },
                    selectNo: () {},
                    visitorName:
                        savedVisitor.fname! + " " + savedVisitor.lname!,
                  );
                },
              );
            }
          },
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisitorDetailsScreen(
                        fname: savedVisitor.fname!,
                        lname: savedVisitor.lname!,
                        imageUrl: savedVisitor.imageUrl!,
                        id: savedVisitor.id!,
                      )));
        },
      );
}
