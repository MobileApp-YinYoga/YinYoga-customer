import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/screens/homepage_screen.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_success.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;

  OtpVerificationScreen({required this.email, required this.otp});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  String _enteredOtp = '';
  String _errorMessage = '';
  bool _isButtonEnabled = false; // Điều kiện enable button

  // Hàm kiểm tra OTP
  void _verifyOtp() {
    if (_enteredOtp == widget.otp) {
      // OTP đúng, thực hiện hành động tiếp theo
      print("OTP verified successfully!");
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomSuccessDialog(
                title: 'Success',
                content: 'OTP verified successfully!',
                onConfirm: () {
                  // Navigate to Home Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomepageScreen(),
                    ),
                  );
                },
              ));
    } else {
      // OTP sai, hiển thị thông báo lỗi
      print("Invalid OTP.");
      setState(() {
        _errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  // Hàm kiểm tra xem đã nhập đủ OTP chưa
  void _updateOtp() {
    String otp = '';
    for (var controller in _otpControllers) {
      otp += controller.text;
    }

    setState(() {
      _enteredOtp = otp;
      _isButtonEnabled = otp.length == 6; // Kiểm tra đủ 6 ký tự
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6D674B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/welcome_image_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF6D674B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We have sent the verification code to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Color(0xFF6D674B),
                ),
              ),
              const SizedBox(height: 30),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6D674B),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF6D674B),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      onChanged: (value) {
                        _updateOtp();
                      },
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6D674B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: '-',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _verifyOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D674B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
