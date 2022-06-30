import 'package:flutter/material.dart';
import 'package:flutter_doorbell/models/saved_visitor.dart';
import 'package:flutter_doorbell/models/user.dart';
import 'package:flutter_doorbell/widgets/profile/accordion.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List visitors;
  final User user = User(name: "Gimhan", email: "gimhanr9@gmail.com");

  @override
  void initState() {
    visitors = getSavedVisitors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Profile"),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Accordion(
                title: "My Details",
                user: user,
              ),
              Accordion(
                title: "Visitor Details",
                visitors: visitors,
              )
            ],
          ),
        ));
  }
}

List getSavedVisitors() {
  return [
    SavedVisitor(
      fname: "Sam",
      lname: "Curran",
      imageUrl:
          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTB8fHxlbnwwfHx8fA%3D%3D&w=1000&q=80",
    )
  ];
}
