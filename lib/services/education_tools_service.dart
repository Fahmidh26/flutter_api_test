import 'dart:convert';
import 'package:fitness/model/education_tool.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.0.106:8000/api"; // Change this to your Laravel API URL

  static Future<List<EducationTool>> fetchEducationTools() async {
    final response = await http.get(Uri.parse('$baseUrl/education/tools'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['tools'];
      return data.map((json) => EducationTool.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load education tools");
    }
  }
}
