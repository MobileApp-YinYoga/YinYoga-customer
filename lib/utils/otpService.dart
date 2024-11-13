import 'dart:convert';
import 'package:http/http.dart' as http;

class MailgunService {
  // Hàm gửi email thông qua Mailgun API
  Future<String> sendEmail(String toEmail) async {
    String _otp = ''; // Mã OTP sẽ được gửi qua email

    // Địa chỉ API của server Node.js
    final url = Uri.parse(
        'http://192.168.2.24:3000/send-opt'); // Đảm bảo rằng server Node.js đang chạy tại localhost hoặc IP của máy chủ của bạn

    try {
      // Gửi yêu cầu POST tới server để gửi OTP
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': toEmail}), // Gửi email vào body request
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Sended OTP: $responseData['otp']");

        return responseData['otp']; // Nhận OTP từ phản hồi
      } else {
        print("Failed to send OTP: ${response.body}");
        return '';
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return '';
    }
  }
}
