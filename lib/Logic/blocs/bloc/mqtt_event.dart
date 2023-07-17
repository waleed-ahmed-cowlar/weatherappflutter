part of 'mqtt_bloc.dart';

@immutable
abstract class MqttEvent {}

class intialMQttevent extends MqttEvent{

}
class loadedMQTTevent extends MqttEvent{
    final Map<String, dynamic> weatherData;
     loadedMQTTevent({required this.weatherData});



}