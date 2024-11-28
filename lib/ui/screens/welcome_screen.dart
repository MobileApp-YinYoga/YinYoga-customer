import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/screens/email_input_screen.dart';
import 'package:yinyoga_customer/ui/screens/homepage_screen.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    // Get data from SharedPreferences
    String? fullName = await SharedPreferencesHelper.getData('fullName');
    String? email = await SharedPreferencesHelper.getData('email');

    if (fullName != null && email != null) {
      print('User logged in: $fullName, $email');
      // Navigate to Home Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomepageScreen(),
        ),
      );
    } else {
      print('User not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/welcome_image.png',
              fit: BoxFit.cover, // Make sure the image fills the screen
            ),
          ),
          // Content above image
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmailInputScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 50),
                // Distance between button and bottom of screen
              ],
            ),
          ),
        ],
      ),
    );
  }
}
