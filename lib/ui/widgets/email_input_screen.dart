import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Thêm Firestore
import 'package:yinyoga_customer/services/otp_service.dart';
import 'otp_verification_screen.dart';

class EmailInputScreen extends StatefulWidget {
  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _checkEmailAndSendOtp() async {
    final String email = _emailController.text.trim();

    // Kiểm tra email trong Firestore
    bool emailExists = await _checkEmailExists(email);
    if (emailExists) {
      // Email tồn tại - không cần xác thực OTP
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email already exists'),
          content: Text('This email is already registered. You can proceed to login.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Tạo mã OTP ngẫu nhiên
      String otp = OtpService().generateOtp();
      print('OTP Generated: $otp');

      // Điều hướng sang màn hình xác thực OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(email: email, otp: otp),
        ),
      );
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      // Truy vấn Firestore để kiểm tra xem email có tồn tại trong collection 'users' không
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Thay 'users' bằng tên collection của bạn
          .where('email', isEqualTo: email)
          .get();

      // Kiểm tra nếu có kết quả
      if (querySnapshot.docs.isNotEmpty) {
        print('Email already exists: $email');
        return true; // Email tồn tại
      } else {
        print('Email does not exist: $email');
        return false; // Email không tồn tại
      }
    } catch (e) {
      print('Error checking email existence: $e');
      // Xử lý lỗi (nếu cần), có thể hiển thị thông báo lỗi cho người dùng
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkEmailAndSendOtp,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
