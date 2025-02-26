import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fitness/screens/signin_screen.dart';
import 'package:fitness/screens/signup_screen.dart';
import 'package:fitness/theme/theme.dart';
import 'package:fitness/widgets/welcome_button.dart';
import 'package:flutter/material.dart';
import 'package:fitness/widgets/custom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthState(); // Check if the user is already logged in
  }

  Future<void> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve the token
    print('Token retrieved: $token'); // Debug log

    if (token != null) {
      // If the token exists, navigate to the dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Clever Creator Ai',
                              textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              speed: Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                      TextSpan(
                        text: '\nOne stop solution for all your needs',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign In',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign Up',
                      onTap: SignUpScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
