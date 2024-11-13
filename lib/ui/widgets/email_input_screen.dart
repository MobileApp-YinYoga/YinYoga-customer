import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/widgets/otp_verification_screen.dart';
import 'package:yinyoga_customer/utils/otpService.dart'; // Nhập MailgunService từ utils

class EmailInputScreen extends StatefulWidget {
  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = ''; // Lưu trữ thông báo lỗi
  bool _isEmailValid = true; // Kiểm tra tính hợp lệ của email
  bool _isLoading = false; // Kiểm tra trạng thái loading
  bool _isOtpSent = false; // Kiểm tra xem OTP đã được gửi chưa

  Future<void> _checkEmailAndSendOtp() async {
    final String email = _emailController.text.trim();

    // Kiểm tra email hợp lệ
    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
        _isEmailValid = false;
        _isOtpSent = false;
      });
      return; // Nếu email không hợp lệ thì dừng lại
    }

    // Hiển thị loading khi đang gửi OTP
    setState(() {
      _isLoading = true;
    });

    try {
      // Gửi OTP qua email
      String _otp = await MailgunService().sendEmail(email);
      if (_otp.isEmpty == false) {
        setState(() {
          _isLoading = false;
          _isOtpSent = true; // OTP đã được gửi
        });

        // Gửi mã OTP qua email
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: email,
              otp: _otp,
            ),
          ),
        );
      } else {
        // Hiển thị thông báo lỗi nếu không thể gửi OTP
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to send OTP. Please try again later.';
          _isEmailValid = false;
          _isOtpSent = false;
        });
      }
    } catch (e) {
      // Nếu có lỗi khi gửi OTP
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to send OTP. Please try again later.';
        _isEmailValid = false;
        _isOtpSent = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    // Kiểm tra tính hợp lệ của email
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/welcome_image_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tiêu đề chào mừng
              const Text(
                'WELCOME TO UNIVERSAL YOGA',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  color: Color(0xFF6D674B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Join us to improve your mental and physical well-being through yoga. Start by entering your details below to begin your journey with us!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6D674B),
                ),
              ),
              const SizedBox(height: 30),
              // Trường nhập email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF6D674B),
                  ),
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  errorText: _isEmailValid ? null : _errorMessage,
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Nút bấm
              ElevatedButton(
                onPressed: _isOtpSent || _isLoading ? null : _checkEmailAndSendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D674B),
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) // Hiển thị loading khi gửi OTP
                    : const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
