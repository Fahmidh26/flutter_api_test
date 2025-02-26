import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Fetch user data from the API
  static Future<Map<String, dynamic>> fetchUserData() async {
    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('User is not logged in');
    }

    // Make a GET request to the API
    final response = await http.get(
      Uri.parse(
        'http://192.168.0.106:8000/api/user',
      ), // Replace with your API endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse and return the user data
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
