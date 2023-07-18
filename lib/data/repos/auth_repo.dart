import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthRepo {
  static const String baseUrl = "http://10.0.2.2:5000";
  static Map<String, dynamic> currentUser = {};
  static String token = '';
  Dio dio = Dio();

  Future<bool> login(String email, String password) async {
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
      return false;
    }
  }

  Future<bool> createAccount(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      final Response response = await dio.post(
        "$baseUrl/user/createAccount",
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {"fullname": fullname, "email": email, "password": password},
      );

      if (response.data['success'] == true) {
        // currentUser = response.data['user'];
        // token = response.data['token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
