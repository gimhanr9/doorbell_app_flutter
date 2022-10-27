import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

final Dio _dio = Dio();

class HomeApiClient {
  Future getActivityLog(String token) async {
    try {
      Response response = await _dio.get(
          '${dotenv.env['FLASK_API_URL']}/getactivities',
          options: Options(
              headers: {'Authorization': token},
              contentType: Headers.jsonContentType));

      print(response.data);
      print("homewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
