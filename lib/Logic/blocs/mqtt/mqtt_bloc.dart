import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:weatherapp/Presentation/mqtt/mqqt_subscriber.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MQTTClientManager m1 = MQTTClientManager();
  MqttBloc() : super(MqttInitial()) {
    on<MqttEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<MqttupdateWeatherEvent>((event, emit) async {
      emit(MQTTLoadingstate());
      MqttServerClient client = await m1.connect();
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final MqttPublishMessage recMess =
            messages[0].payload as MqttPublishMessage;
        var message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        var jsonmessage = jsonDecode(message);

        print('YOU GOT A NEW MESSAGE:');
        // emit(MQTTerrorState());
        emit(MQTTloadedState(data: jsonmessage));

        // print(jsonDecode(message)['message']);
        // print(message);
      });
    });
  }
}
