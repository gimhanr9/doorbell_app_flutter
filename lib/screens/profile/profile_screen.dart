import 'package:flutter/material.dart';
import 'package:flutter_doorbell/screens/profile/profile_details_screen.dart';
import 'package:flutter_doorbell/screens/profile/visitor_screen.dart';
import 'package:flutter_doorbell/utils/color_file.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: ColorFile.header,
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              text: 'My Details',
              icon: Icon(Icons.account_circle_rounded),
            ),
            Tab(
              text: 'Visitors',
              icon: Icon(Icons.switch_account_rounded),
            )
          ]),
        ),
        body: const TabBarView(
            children: [ProfileDetailsScreen(), VisitorScreen()]),
      ),
    );
  }
}
