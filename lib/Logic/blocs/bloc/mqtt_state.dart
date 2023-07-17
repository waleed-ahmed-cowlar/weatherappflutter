part of 'mqtt_bloc.dart';

@immutable
abstract class MqttState {}

class MqttInitial extends MqttState {}

class loadedMqttstate extends MqttState {
  final Map<String, dynamic> weatherData;
  loadedMqttstate({required this.weatherData});
}
