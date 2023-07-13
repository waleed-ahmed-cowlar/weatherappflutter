import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClientManager {
  MqttServerClient client =
      MqttServerClient.withPort('10.0.2.2', 'mobile_client', 1883);

  Future<MqttServerClient> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    // client.pongCallback = pong;

    final connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      const topic = 'weather';
      client.subscribe(topic, MqttQos.atMostOnce);

// Register the message handler
      // client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      //   final MqttPublishMessage recMess =
      //       messages[0].payload as MqttPublishMessage;
      //   var message =
      //       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      //   // print('YOU GOT A NEW MESSAGE:');

      //   // print(jsonDecode(message)['message']);
      //   // print(message);
      // });
    } on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      client.disconnect();
    }

    return client;
  }

  void messageHandler(String topic, MqttMessage message) {
    // print('Received message: $topic -> $message');
    // String messageString = message.payloadAsString;
    // print(messageString);
    print(message.toString());
  }

  // void disconnect() {
  //   client.disconnect();
  // }

  // void subscribe(String topic) {
  //   client.subscribe('weather', MqttQos.atLeastOnce);
  // }

  void onConnected() {
    print(
        'MQTTClient::Connected==================================================');
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }
}
