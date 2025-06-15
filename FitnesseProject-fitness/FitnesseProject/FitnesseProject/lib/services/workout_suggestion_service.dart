import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutSuggestionService {
  static const String _apiKey = 'd5+YUwxQVexxyzm0gIygJA==f9IZ49KjGUtTaOtO'; // Remplacez par votre clé API
  static const String _baseUrl = 'api.api-ninjas.com';

  static Future<List<dynamic>> fetchSuggestions({String? type, String? muscle, String? difficulty}) async {
    final url = Uri.https(_baseUrl, '/v1/exercises', {
      if (type != null && type.isNotEmpty) 'type': type,
      if (muscle != null && muscle.isNotEmpty) 'muscle': muscle,
      if (difficulty != null && difficulty.isNotEmpty) 'difficulty': difficulty,
    });

    final response = await http.get(url, headers: {'X-Api-Key': _apiKey});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des suggestions');
    }
  }
} 