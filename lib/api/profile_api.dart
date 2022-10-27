import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProfileApiClient {
  final Dio _dio = Dio();

  Future getProfile(String token) async {
    try {
      Response response = await _dio.get(
          '${dotenv.env['FLASK_API_URL']}/getprofile',
          options: Options(
              headers: {'Authorization': token},
              contentType: Headers.jsonContentType));

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future getVisitors(String token) async {
    try {
      Response response = await _dio.get(
          '${dotenv.env['FLASK_API_URL']}/getvisitors',
          options: Options(
              headers: {'Authorization': token},
              contentType: Headers.jsonContentType));

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future editProfile(String token, String name, String email) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/editprofile',
          options: Options(
              headers: {'Authorization': token},
              contentType: Headers.jsonContentType),
          data: jsonEncode({'email': email, 'name': name}));

      Map<String, dynamic> map = {'data': response.data['data']};

      return map;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future addVisitor(
      String token, File imageFile, String fname, String lname) async {
    try {
      String fileName = imageFile.path.split('/').last;
      String? mimeType = mime(fileName);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType(mimee, type),
        ),
        'fname': fname,
        'lname': lname
      });
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/addvisitor',
          options: Options(headers: {'Authorization': token}),
          data: data);

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future editVisitor(String token, File imageFile, String previousUrl,
      String fname, String lname) async {
    try {
      String fileName = imageFile.path.split('/').last;
      String? mimeType = mime(fileName);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      FormData data = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType(mimee, type),
        ),
        'image_url': previousUrl,
        'fname': fname,
        'lname': lname
      });
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/editvisitor',
          options: Options(headers: {'Authorization': token}),
          data: data);

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future deleteVisitor(String token, String visitorId, String imageUrl) async {
    try {
      Response response = await _dio.post(
          '${dotenv.env['FLASK_API_URL']}/deletevisitor',
          options: Options(
              headers: {'Authorization': token},
              contentType: Headers.jsonContentType),
          data: jsonEncode({'id': visitorId, 'image_url': imageUrl}));

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
