import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherapp/data/repos/weather_repo.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepository weatherRepository = WeatherRepository();

  WeatherBloc() : super(WeatherLoadingState()) {
    on<WeatherEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchWeatherEvent>((event, emit) async {
      try {
        emit(WeatherLoadingState());
        Map<String, dynamic> weatherDetails =
            await weatherRepository.getWeatherDetails();
        // await Future.delayed(const Duration(seconds: 5));
        emit(WeatherLoadedState(weatherModel: weatherDetails));
      } catch (e) {
        emit(WeatherErrorState(message: e.toString()));
      }
    });
    on<SaveWeatherEvent>((event, emit) async {
      print('Save Weather Event');
      emit(WeatherSavingState());
      bool saved = await weatherRepository.saveWeathertoDb(event.weatherData);
      if (saved) {
        emit(WeatherSavedState());
      } else {
        emit(WeatherSaveErrorState(message: 'Error Saving Weather'));
      }
    });

    on<ShowSavedWeatherButtonEvent>((event, emit) async {
      emit(FetchingSavedWeatherState());
      try {
        bool success = await weatherRepository.getSavedWeather();
        if (success) {
          emit(FetchedSavedWeatherState(
              weatherModel: WeatherRepository.savedWeather));
        }
      } catch (e) {
        emit(FetchingSavedWeatherErrorState(message: e.toString()));
      }
    });
  }
}
