import 'package:alert_system/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class WeatherTab extends StatelessWidget {
  const WeatherTab({super.key});

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
                      text: 'September 18, 2024',
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
                        text: '27°C',
                        fontSize: 80,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                    // Weather Description
                    TextWidget(
                      text: 'Sunny',
                      fontSize: 24,
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WeatherDetailWidget(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '15 km/h',
                    ),
                    WeatherDetailWidget(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '65%',
                    ),
                    WeatherDetailWidget(
                      icon: Icons.speed,
                      label: 'Pressure',
                      value: '1015 hPa',
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
