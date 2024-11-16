import 'dart:convert';
import 'package:http/http.dart' as http;

class MailgunService {
  // Hàm gửi email thông qua Mailgun API
  Future<String> sendEmail(String toEmail) async {
    String _otp = ''; // Mã OTP sẽ được gửi qua email

    // Địa chỉ API của server Node.js
    final url = Uri.parse(
        'http://10.26.8.87:3000/send-opt'); // Đảm bảo rằng server Node.js đang chạy tại localhost hoặc IP của máy chủ của bạn

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

  Future<void> sendRegistrationSuccessEmail(
      String toEmail, String courseName) async {
    final url = Uri.parse(
        'http://10.26.8.87:3000/send-registration-success'); // Đảm bảo URL này là đúng

    try {
      print("MailgunService: Sending registration email to $toEmail - $courseName");
      // Gửi yêu cầu POST tới server
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': toEmail, // Gửi email vào request
          'courseName': courseName // Tên khóa học
        }),
      );

      if (response.statusCode == 200) {
        print('Registration success email sent successfully');
      } else {
        print("Failed to send registration email: ${response.body}");
      }
    } catch (e) {
      print('Error sending registration email: $e');
    }
  }
}
