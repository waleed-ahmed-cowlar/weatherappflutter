// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'mqtt_bloc.dart';

abstract class MqttState {}

class MqttInitial extends MqttState {}

class MQTTLoadingstate extends MqttState {}

class MQTTloadedState extends MqttState {
  Map<String, dynamic> data;
  MQTTloadedState({
    required this.data,
  });
}

class MQTTerrorState extends MqttState {}
