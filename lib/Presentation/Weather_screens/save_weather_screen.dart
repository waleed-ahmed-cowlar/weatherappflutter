import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/Logic/blocs/weather_/bloc/weather_bloc.dart';
import 'package:weatherapp/data/repos/weather_repo.dart';

class SaveWeatherScreen extends StatefulWidget {
  const SaveWeatherScreen({super.key});

  @override
  State<SaveWeatherScreen> createState() => _SaveWeatherScreenState();
}

class _SaveWeatherScreenState extends State<SaveWeatherScreen> {
  WeatherBloc weatherBloc = WeatherBloc();
  @override
  void initState() {
    // TODO: implement initState
    weatherBloc.add(ShowSavedWeatherButtonEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        bloc: weatherBloc,
        builder: (context, state) {
          if (state is FetchingSavedWeatherState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchingSavedWeatherErrorState) {
            return const Center(child: Text("Error"));
          }
          return ListView.builder(
            itemCount: WeatherRepository.savedWeather.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title:
                    Text("${WeatherRepository.savedWeather[index]['temp']}°C"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('dd/MM/yy  HH:mm:ss').format(DateTime.parse(
                        "${WeatherRepository.savedWeather[index]['date']}"))),
                    // Text("${WeatherRepository.savedWeather[index]['date']}"),
                    Text(
                        "${WeatherRepository.savedWeather[index]['wind_speed']} km/h"),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    // weatherBloc.add(DeleteWeatherEvent(index: index));
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
