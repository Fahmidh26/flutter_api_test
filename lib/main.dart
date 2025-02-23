import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApiTestScreen(),
    );
  }
}

class ApiTestScreen extends StatefulWidget {
  @override
  ApiTestScreenState createState() => ApiTestScreenState();
}

class ApiTestScreenState extends State<ApiTestScreen> {
  String _response = "Press the button to test API";

  Future<void> testApiConnection() async {
    var url = Uri.parse("http://192.168.0.106:8000/api/prompt/manage");

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _response = "✅ Connected! Response: ${response.body}";
        });
      } else {
        setState(() {
          _response = "❌ Error: ${response.statusCode} - ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "🚨 Connection failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Test")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _response,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: testApiConnection,
                child: Text("Test API"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
