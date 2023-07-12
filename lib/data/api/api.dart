import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  final Dio _dio = Dio();
  Api() {
    _dio.options.baseUrl = "https://weather-by-api-ninjas.p.rapidapi.com/v1";
    _dio.options.receiveTimeout = const Duration(seconds: 5);
    _dio.interceptors.add(PrettyDioLogger());
  }
  Dio get sendrequest => _dio;
}
