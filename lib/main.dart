import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Updated constructor with a key parameter (even though it's optional in this case)
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  // Updated constructor with a key parameter
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _isLoading = false;

  // Function to register user
  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    // Get values from text controllers
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordConfirmation = _passwordConfirmationController.text;

    // Define the URL for your API
    String url =
        'http://192.168.0.106:8000/api/register'; // Change the IP if necessary

    try {
      // Prepare headers for the request
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'X-Auth-Hex': 'your-auth-hex-value', // Add the necessary header
      };

      // Prepare the body of the request
      Map<String, String> body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      // Check if the response is successful
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text(responseData['message']),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
          );
        }
      } else {
        final responseData = json.decode(response.body);
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(
                    responseData['message'] ?? 'Something went wrong',
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong!'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _passwordConfirmationController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
          ],
        ),
      ),
    );
  }
}
