import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../Logic/blocs/bloc/mqtt_bloc.dart';
import 'mqqt_subscriber.dart';

class MQTTScreen extends StatefulWidget {
  const MQTTScreen({super.key});

  @override
  State<MQTTScreen> createState() => _MQTTScreenState();
}

class _MQTTScreenState extends State<MQTTScreen> {
  late MqttServerClient client;
  // final mqttBloc = MqttBloc();
  int count = 0;
  @override
  void initState() {
    // mqttBloc.add(intialMQttevent());
    initialize();

    super.initState();
  }

  void initialize() async {
    client = await m1.connect();
    //   client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
    //     final MqttPublishMessage recMess =
    //         messages[0].payload as MqttPublishMessage;
    //     var message =
    //         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //     var jsonmessage = jsonDecode(message);
    //     weatherData = jsonmessage;
    //     print(weatherData['current']['temp_c']);
    //     count++;
    //     setState(() {
    //       print('updating');
    //     });
    //     print('YOU GOT A NEW MESSAGE:================');
    //     // emit(MQTTerrorState());
    //     // emit(MQTTloadedState(data: jsonmessage));

    //     // print(jsonDecode(message)['message']);
    //     // print(message);
    //   });
    //   // Perform any other necessary operations with the client
  }

  MQTTClientManager m1 = MQTTClientManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MQQT data Screen")),
      body: Center(
          child: BlocBuilder<MqttBloc, MqttState>(
        bloc: mqttBloc,
        builder: (context, state) {
          if (state is loadedMqttstate) {
            print('rebuild');
            print(state.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${state.weatherData['location']['localtime']}"),
                Text("${state.weatherData['current']['temp_c']} C"),
                Text("${state.weatherData['current']['last_updated']}"),
                Text(count.toString())
              ],
            );
          } else {
            return Text(state.toString());
            // return const CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
