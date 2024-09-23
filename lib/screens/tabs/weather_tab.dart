import 'dart:convert';

import 'package:alert_system/utils/const.dart';
import 'package:alert_system/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as location1;
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class WeatherTab extends StatefulWidget {
  const WeatherTab({super.key});

  @override
  State<WeatherTab> createState() => _WeatherTabState();
}

class _WeatherTabState extends State<WeatherTab> {
  @override
  void initState() {
    super.initState();
    getApiData(13.982831, 121.100395);
  }

  getApiData(lat, long) async {
    var uri = '$apiEnpoint?lat=$lat&lon=$long&appid=$apiKey';
    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        // Request was successful
        var data = json.decode(response.body);
        var weatherDescription = data['weather'][0]['description'];
        var temperatureKelvin = data['main']['temp'];
        double temperatureCelsius =
            temperatureKelvin - 273.15; // Convert from Kelvin to Celsius
        var pressure1 = data['main']['pressure'];
        var humidity = data['main']['humidity'];
        var windSpeed = data['wind']['speed'];

        setState(() {
          wind = windSpeed.toString();
          hum = humidity.toString();
          pressure = pressure1.toString();
          temp = temperatureCelsius.toStringAsFixed(0);
          desc = weatherDescription;
        });

        print('Weather Description: $weatherDescription');
        print('Temperature: ${temperatureCelsius.toStringAsFixed(2)}°C');
        print('Pressure: $pressure');
        print('Humidity: $humidity');
        print('Wind Speed: $windSpeed');
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');

        // Show error snackbar
      }
    } catch (e) {
      // An error occurred
      print('Error: $e');

      // Show error snackbar
    }
  }

  String wind = '0';
  String hum = '0';
  String pressure = '0';
  String temp = '0';

  String desc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // City and Date Information
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    TextWidget(
                      text: 'Mataasnakahoy',
                      fontSize: 30,
                      isBold: true,
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),

              // Weather Icon and Temperature
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Weather Icon
                    const Icon(
                      Icons.wb_sunny,
                      size: 120,
                      color: Colors.white,
                    ),
                    // Temperature
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextWidget(
                        text: '$temp°C',
                        fontSize: 80,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                    // Weather Description
                    TextWidget(
                      text: desc,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Weather Details
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherDetailWidget(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '$wind km/h',
                    ),
                    WeatherDetailWidget(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$hum%',
                    ),
                    WeatherDetailWidget(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '$pressure hPa',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetailWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        TextWidget(
          text: label,
          fontSize: 18,
          color: Colors.white70,
        ),
        const SizedBox(height: 4),
        TextWidget(
          text: value,
          fontSize: 16,
          color: Colors.white,
          isBold: true,
        ),
      ],
    );
  }
}
