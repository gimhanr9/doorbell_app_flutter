import 'dart:convert';

import 'package:flutter_doorbell/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

Future<http.Response?> login(User user) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var response = await client.post(
      Uri.parse('${dotenv.env['FLASK_API_URL']}/login'),
      headers: requestHeaders,
      body: jsonEncode({'email': user.email, 'password': user.password}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response?> register(User user) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var response = await client.post(
      Uri.parse('${dotenv.env['FLASK_API_URL']}/register'),
      headers: requestHeaders,
      body: jsonEncode(
          {'email': user.email, 'name': user.name, 'password': user.password}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response?> resetPassword(User user) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var response = await client.post(
      Uri.parse('${dotenv.env['FLASK_API_URL']}/resetPassword'),
      headers: requestHeaders,
      body: jsonEncode({'email': user.email}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response?> checkOtp(User user) async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var response = await client.post(
      Uri.parse('${dotenv.env['FLASK_API_URL']}/checkOtp'),
      headers: requestHeaders,
      body: jsonEncode({'otp': user.otp}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}
