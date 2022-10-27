import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doorbell/screens/home/home_screen.dart';
import 'package:flutter_doorbell/screens/login/login_screen.dart';
import 'package:flutter_doorbell/utils/my_http_overrides.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  await dotenv.load();
  await OneSignal.shared.setAppId('${dotenv.env['ONE_SIGNAL_APP_ID']}');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool value = preferences.containsKey('userToken');
  runApp(MyApp(
    value: value,
  ));
}

class MyApp extends StatelessWidget {
  final bool? value;
  const MyApp({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Doorbell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: value == false || value == null
          ? const LoginScreen()
          : const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
