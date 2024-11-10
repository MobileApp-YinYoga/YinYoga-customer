import 'package:flutter/material.dart';
import '../screens/homepage_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;

  OtpVerificationScreen({required this.email, required this.otp});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOtp() {
    if (_otpController.text == widget.otp) {
      // OTP hợp lệ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomepageScreen()),
      );
    } else {
      // OTP không hợp lệ
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid OTP'),
          content: Text('The OTP you entered is incorrect.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the 6-digit OTP sent to ${widget.email}'),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
