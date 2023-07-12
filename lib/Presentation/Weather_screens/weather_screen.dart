import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Presentation/Weather_screens/save_weather_screen.dart';
import 'package:weatherapp/data/repos/weather_repo.dart';

import '../../Logic/blocs/weather_/bloc/weather_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherBloc weatherBloc = WeatherBloc();
  @override
  void initState() {
    weatherBloc.add(FetchWeatherEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
            icon: const Icon(Icons.dark_mode),
          ),
        ],
        title: const Text("Weather App"),
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        bloc: weatherBloc,

        buildWhen: (previous, current) {
          if (current is! WeatherSavingState && current is! WeatherSavedState) {
            print(current.toString());
            print('builing');
            return true;
          }
          return false;
        },
        listenWhen: (previous, current) {
          if (current is WeatherSaveErrorState ||
              current is WeatherSavedState) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is WeatherErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is WeatherSavedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Weather Saved to DB'),
              ),
            );
          } else if (state is WeatherSaveErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

          // TODO: implement listener
        },
        // buildWhen: (previous, current) => current is WeatherLoadingState,
        builder: (context, state) {
          print(state.toString());
          print('rebuild');

          if (state is WeatherLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherErrorState) {
            return Center(child: Text(state.message));
          } else if (state is WeatherLoadedState) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Temperature: ${state.weatherModel['temp']} C°',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          weatherBloc.add(FetchWeatherEvent());
                        },
                        icon: const Icon(Icons.replay_outlined)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Wind Speed: ${state.weatherModel['wind_speed']} Km/h'),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.waves,
                      size: 40,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        weatherBloc.add(SaveWeatherEvent(
                            weatherData: WeatherRepository.currentWeather));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                      ),
                      child: const Text('Save to DB'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(() => const SaveWeatherScreen());
                        },
                        child: const Text('Show Saved Data '))
                  ],
                )
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
