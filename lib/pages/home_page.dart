import 'package:flutter/material.dart';
import '../api/weather_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final WeatherApi _weatherApi = WeatherApi();
  String? _temperature;
  String? _cityName;
  String? _windSpeed;
  int? _weatherCode;
  String? _errorMessage;
  bool _isLoading = false;
  late AnimationController _rotationController;
  String? _humidity;
  String? _feel;
  String? _uvIndex;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _searchWeather() async {
    try{
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _temperature = null;
        _cityName = null;
        _windSpeed = null;
        _weatherCode = null;
        _humidity = null;
        _feel = null;
        _uvIndex = null;
      });

      final city = _cityController.text;
      if (city.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Saisissez une ville';
        });
        return;
      }
      final coordinates = await _weatherApi.getCoordinates(city);
      if (coordinates == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Ville introuvable';
        });
        return;
      }

      final weather = await _weatherApi.getWeather(
        coordinates['latitude'],
        coordinates['longitude'],
      );
      if (weather == null) return;

      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _temperature = (weather['temperature_2m'] as double).round().toString();
        _windSpeed = weather['wind_speed_10m'].toString();
        _cityName = coordinates['name'];
        _weatherCode = weather['weather_code'];
        _humidity = weather['relative_humidity_2m'].toString();
        _feel = weather['apparent_temperature'].toString();
        _uvIndex = weather['uv_index'].toString();
      });
    } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur réseau, vérifiez votre connexion.';
        });
    }
  }

  String _getWeatherImage(int code) {
    if (code == 0) return 'assets/images/soleil.png';
    if (code <= 3) return 'assets/images/nuage.png';
    if (code <= 67) return 'assets/images/pluie.png';
    if (code <= 77) return 'assets/images/neige.png';
    return 'assets/images/orage.png';
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
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'Nom de votre ville',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: _searchWeather,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                    child: Image.asset(
                      'assets/images/loupe.png',
                      height: 24,
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Expanded(
                  child: Center(
                    child: RotationTransition(
                      turns: _rotationController,
                      child: Image.asset(
                        'assets/images/spinner.png',
                        height: 80,
                      ),
                    ),
                  ),
                ),
              if (_errorMessage != null)
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                            Image.asset(
                              _getWeatherImage(_weatherCode!),
                              height: 120,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            _cityName ?? '',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 53, 53, 53),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$_temperature°c',
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 53, 53, 53),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Image.asset('assets/images/vent.png', height: 24),
                                  const SizedBox(height: 4),
                                  Text('Vent : $_windSpeed km/h'),
                                  const SizedBox(height: 16),
                                  Image.asset('assets/images/eau.png', height: 24),
                                  const SizedBox(height: 4),
                                  Text('Humidité : $_humidity %'),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset('assets/images/temperature.png', height: 24),
                                  const SizedBox(height: 4),
                                  Text('Ressenti : $_feel°'),
                                  const SizedBox(height: 16),
                                  Image.asset('assets/images/soleil.png', height: 24),
                                  const SizedBox(height: 4),
                                  Text('UV : $_uvIndex'),
                                ],
                              ),
                            ],
                          ),
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