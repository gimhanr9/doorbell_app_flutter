import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

final Dio _dio = Dio();

Future<Response> getActivityLog(String token) async {
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
