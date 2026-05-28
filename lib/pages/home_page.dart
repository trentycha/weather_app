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
      _temperature = (weather['temperature_2m'] as double).round().toString();
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 71, 126, 171),
              Color.fromARGB(255, 165, 213, 235),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Votre météo du jour !',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
              ElevatedButton(
                onPressed: _searchWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Rechercher',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              if (_temperature != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 54.0),
                      child: Column(
                        children: [
                          if (_weatherCode != null)
                            Icon(
                              _getWeatherIcon(_weatherCode!),
                              size: 120,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            _cityName ?? '',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$_temperature°',
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Vent : $_windSpeed km/h'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}