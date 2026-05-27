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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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
                  onPressed: () {},
                  child: const Text('Rechercher'),
                ),
              ),
            const SizedBox(height: 32),
            const Text('coucou'),
          ],
        ),
      ),
    );
  }
}