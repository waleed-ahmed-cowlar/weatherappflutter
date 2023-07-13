import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthRepo {
  static const String baseUrl = "http://10.0.2.2:5000";
  static Map<String, dynamic> currentUser = {};
  static String token = '';

  Future<bool> login(String email, String password) async {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    try {
      final Response response = await dio.post(
        "$baseUrl/user/login",
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {"email": email, "password": password},
      );

      if (response.data['success'] == true) {
        currentUser = response.data['user'];
        token = response.data['token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
