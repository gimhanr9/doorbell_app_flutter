import 'dart:convert';

import 'package:flutter_doorbell/models/user.dart';
import 'package:flutter_doorbell/utils/network_exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class AuthApiClient {
  final Dio _dio = Dio();

  Future login(String email, String password) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/login',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode({'email': email, 'password': password}));

      Map<String, dynamic> map = json.decode(response.data);

      return map;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      final Map<String, dynamic> mapError = {
        'error': 'Request Failed',
        'data': null,
        'message': errorMessage
      };
      return mapError;
    }
  }

  Future register(User user) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/register',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode({
            'email': user.email,
            'name': user.name,
            'password': user.password
          }));

      Map<String, dynamic> map = json.decode(response.data);

      return map;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      final Map<String, dynamic> mapError = {
        'error': 'Request Failed',
        'data': null,
        'message': errorMessage
      };
      return mapError;
    }
  }

  Future resetPassword(String email, String password) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/resetpassword',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode({'email': email, 'password': password}));

      Map<String, dynamic> map = json.decode(response.data);

      return map;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      final Map<String, dynamic> mapError = {
        'error': 'Request Failed',
        'data': null,
        'message': errorMessage
      };
      return mapError;
    }
  }

  Future checkOtp(String email, String otp) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/checkotp',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode({'email': email, 'otp': otp}));

      Map<String, dynamic> map = json.decode(response.data);
      return map;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      final Map<String, dynamic> mapError = {
        'error': 'Request Failed',
        'data': null,
        'message': errorMessage
      };
      return mapError;
    }
  }

  Future forgotPassword(String email) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/forgotpassword',
          options: Options(contentType: Headers.jsonContentType),
          data: jsonEncode({'email': email}));

      Map<String, dynamic> map = json.decode(response.data);
      return map;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      final Map<String, dynamic> mapError = {
        'error': 'Request Failed',
        'data': null,
        'message': errorMessage
      };
      return mapError;
    }
  }
}
