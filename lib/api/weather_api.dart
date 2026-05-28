import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApi {

  Future<Map<String, dynamic>?> getCoordinates(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        return data['results'][0];
      }
    }

    return null;
  }

  Future<Map<String, dynamic>?> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m,weather_code,relative_humidity_2m,apparent_temperature,uv_index&timezone=auto',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current'];
    }

    return null;
  }
}