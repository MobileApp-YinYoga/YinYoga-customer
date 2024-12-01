import 'dart:convert';
import 'package:http/http.dart' as http;

class MailService {
  Future<String> sendEmail(String toEmail, String otp) async {
    String _otp = '';

    final url = Uri.parse(
        'http://10.26.8.176:3000/send-opt'); 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': toEmail}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Sended OTP: $responseData['otp']");

        return responseData['otp'];
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
        'http://10.26.8.176:3000/send-registration-success');

    try {
      print("MailgunService: Sending registration email to $toEmail - $courseName");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': toEmail,
          'courseName': courseName
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
