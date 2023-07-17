import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

MqttBloc mqttBloc = MqttBloc();

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttBloc() : super(MqttInitial()) {
    on<MqttEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<intialMQttevent>((event, emit) => emit(MqttInitial()));

    on<loadedMQTTevent>((event, emit) {
      print('event fired');
      emit(loadedMqttstate(weatherData: event.weatherData));
    });
  }
}
