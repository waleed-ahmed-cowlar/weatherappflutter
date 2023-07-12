part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {}

class SaveWeatherEvent extends WeatherEvent {
  final Map<String, dynamic> weatherData;
  SaveWeatherEvent({required this.weatherData});
}

class ShowSavedWeatherButtonEvent extends WeatherEvent {}
