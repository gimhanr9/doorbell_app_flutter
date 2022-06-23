import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString("userToken");
  //var isLoggedIn = await checkAuth();

  var response = await client.post(
      Uri.parse('${dotenv.env['NODE_API_URL']}/start'),
      headers: requestHeaders,
      body: jsonEncode({'token': token}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response = await http.get(
      Uri.parse('${dotenv.env['NODE_API_URL']}/join?meetingId=$meetingId'));

  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }

  throw UnsupportedError('Not a valid meeting');
}
