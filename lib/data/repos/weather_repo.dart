import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weatherapp/data/api/api.dart';
import 'package:weatherapp/data/local_db/sql_helper.dart';
import 'package:weatherapp/data/repos/auth_repo.dart';

class WeatherRepository {
  final Api _api = Api();
  Dio dio = Dio();
  final db = SqlHelper.db();
  static Map<String, dynamic> currentWeather = {};
  static List<dynamic> savedWeather = [];
  Future<Map<String, dynamic>> getWeatherDetails() async {
    try {
      final response = await _api.sendrequest.get("/weather",
          queryParameters: {"city": "Islamabad"},
          options: Options(headers: {
            'X-RapidAPI-Key':
                '494652bd70mshf875d650ddd4191p15327djsn0e2c8da76813',
            'X-RapidAPI-Host': 'weather-by-api-ninjas.p.rapidapi.com'
          }));
      currentWeather = response.data;
      print(response.data['temp']);
      int id = await SqlHelper.saveWeatherTosqflite(
          response.data['temp'].toDouble(), response.data['wind_speed'].toDouble());
      print("${id}of saved entry");

      return response.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> saveWeathertoDb(Map<String, dynamic> weatherData) async {
    try {
      dio.interceptors.add(PrettyDioLogger());
      weatherData['user'] = AuthRepo.currentUser['_id'];

      final response = await dio.post('${AuthRepo.baseUrl}/weather/saveWeather',
          data: weatherData);
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> getSavedWeather() async {
    try {
      dio.interceptors.add(PrettyDioLogger());
      final response = await dio.get('${AuthRepo.baseUrl}/weather/getweather',
          data: {"user": AuthRepo.currentUser["_id"]},
          options: Options(headers: {
            "auth-token": AuthRepo.token,
            "userid": AuthRepo.currentUser["userid"]
          }));
      if (response.data['success'] == true) {
        savedWeather = response.data['data'];
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
