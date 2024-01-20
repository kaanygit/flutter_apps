import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  static Future<Map<String, dynamic>> getWeatherData(String city) async {
    await dotenv.load(fileName: '.env');
    final String apikey = dotenv.env['WHEATHER_API'] as String;
    String apiUrl = '$BASE_URL?q=$city&appid=$apikey&units=metric';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        return data;
      } else {
        throw Exception('Hava durumu bilgileri alınamadı');
      }
    } catch (e) {
      throw Exception('Hata Oluştu: $e');
    }
  }
}
