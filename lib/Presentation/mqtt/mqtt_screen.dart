import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqqt_subscriber.dart';

class MQTTScreen extends StatefulWidget {
  const MQTTScreen({super.key});

  @override
  State<MQTTScreen> createState() => _MQTTScreenState();
}

class _MQTTScreenState extends State<MQTTScreen> {
  late MqttServerClient client;
  int count = 0;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    client = await m1.connect();
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage recMess =
          messages[0].payload as MqttPublishMessage;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var jsonmessage = jsonDecode(message);
      weatherData = jsonmessage;
      print(weatherData['current']['temp_c']);
      count++;
      setState(() {
        print('updating');
      });
      print('YOU GOT A NEW MESSAGE:================');
      // emit(MQTTerrorState());
      // emit(MQTTloadedState(data: jsonmessage));

      // print(jsonDecode(message)['message']);
      // print(message);
    });
    // Perform any other necessary operations with the client
  }

  MQTTClientManager m1 = MQTTClientManager();
  Map<String, dynamic> weatherData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MQQT data Screen")),
      body: weatherData.isEmpty
          ? const Center(
              child: Text('no data fetched yet'),
            )
          : Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${weatherData['location']['localtime']}"),
                Text("${weatherData['current']['temp_c']} C"),
                Text("${weatherData['current']['last_updated']}"),
                Text(count.toString())
              ],
            )),
    );
  }
}
