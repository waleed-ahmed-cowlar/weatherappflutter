import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:weatherapp/data/api/api.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Station',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String broker =
      '4e9852a5cc5948ef914c732fe4200740.s2.eu.hivemq.cloud'; // Replace with your MQTT broker address
  final int port = 8883; // Replace with your MQTT broker port
  final String topic = 'weather'; // MQTT topic to publish the data
  final String apiKey = 'your_api_key'; // Replace with your weather API key
  final String city = 'your_city'; // Replace with your city

  MqttServerClient? client;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    setupMqtt();
  }

  Future<void> setupMqtt() async {
    client = MqttServerClient.withPort(broker, 'flutter_client', port);
    client!.logging(on: true);

    client!.onConnected = onMqttConnected;
    client!.onDisconnected = onMqttDisconnected;

    try {
      await client!.connect();
    } catch (e) {
      print('Exception: $e');
    }
  }

  void onMqttConnected() {
    setState(() {
      connected = true;
    });
  }

  void onMqttDisconnected() {
    setState(() {
      connected = false;
    });
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      Api api = Api();
      final response = await api.sendrequest.get("/weather",
          queryParameters: {"city": "Islamabad"},
          options: Options(headers: {
            'X-RapidAPI-Key':
                '494652bd70mshf875d650ddd4191p15327djsn0e2c8da76813',
            'X-RapidAPI-Host': 'weather-by-api-ninjas.p.rapidapi.com'
          }));
      if (response.statusCode == 200) {
        final weatherData = response.data;
        return weatherData;
      } else {
        throw Exception('Failed to fetch weather data');
      }
      // currentWeather = response.data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void publishWeatherData(Map<String, dynamic> weatherData) {
    final payload = jsonEncode(weatherData);
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Station'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            connected
                ? const Text('Connected to MQTT broker')
                : const Text('Connecting to MQTT broker...'),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Fetch Weather Data'),
              onPressed: () async {
                final weatherData = await getWeatherData();
                publishWeatherData(weatherData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
