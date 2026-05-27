import 'package:flutter/material.dart';
import '../api/weather_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherApi _weatherApi = WeatherApi();
  String? _temperature;
  String? _cityName;
  String? _windSpeed;
  int? _weatherCode;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _searchWeather() async {
    final city = _cityController.text;
    final coordinates = await _weatherApi.getCoordinates(city);
    if (coordinates == null) return;

    final weather = await _weatherApi.getWeather(
      coordinates['latitude'],
      coordinates['longitude'],
    );
    if (weather == null) return;

    setState(() {
      _temperature = weather['temperature_2m'].toString();
      _windSpeed = weather['wind_speed_10m'].toString();
      _cityName = coordinates['name'];
      _weatherCode = weather['weather_code'];
    });
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 67) return Icons.grain;
    if (code <= 77) return Icons.ac_unit;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Votre météo du jour !',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 32),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la ville',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),
              SizedBox(
                child: ElevatedButton(
                  onPressed: _searchWeather,
                  child: const Text('Rechercher'),
                ),
              ),
            const SizedBox(height: 32),
            if (_temperature != null) 
            Card(
              child: Padding (padding:  const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Ville: $_cityName', style: const TextStyle(fontSize: 20)),
                  Text('Température: $_temperature °C', style: const TextStyle(fontSize: 20)),
                  Text('Vitesse du vent: $_windSpeed km/h', style: const TextStyle(fontSize: 20)),
                  if (_weatherCode != null)
                    Icon(
                      _getWeatherIcon(_weatherCode!),
                      size: 48,
                    ),
                  const SizedBox(height: 8),
                ],
              )
              ,)
            ),
          ],
        ),
      ),
    );
  }
}