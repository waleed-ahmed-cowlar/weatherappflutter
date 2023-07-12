part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherActionState extends WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final Map<String, dynamic> weatherModel;

  WeatherLoadedState({required this.weatherModel});
  // final WeatherModel weatherModel;
  // weatherLoadedState({required this.weatherModel});
}

class WeatherSavingState extends WeatherState {}

class WeatherSavedState extends WeatherState {}

class WeatherSaveErrorState extends WeatherState {
  final String message;
  WeatherSaveErrorState({required this.message});
}

class FetchingSavedWeatherState extends WeatherState {}

class FetchedSavedWeatherState extends WeatherState {
  final List<dynamic> weatherModel;

  FetchedSavedWeatherState({required this.weatherModel});
}

class FetchingSavedWeatherErrorState extends WeatherState {
  final String message;
  FetchingSavedWeatherErrorState({required this.message});
}

class WeatherErrorState extends WeatherState {
  final String message;
  WeatherErrorState({required this.message});
}
