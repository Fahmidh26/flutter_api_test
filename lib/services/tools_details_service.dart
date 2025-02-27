import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.0.106:8000/api"; // Update with your API URL

  // Fetch Education Tool details by ID
  static Future<Map<String, dynamic>> fetchToolDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/tool/$id/{slug}'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load tool details");
    }
  }
}
