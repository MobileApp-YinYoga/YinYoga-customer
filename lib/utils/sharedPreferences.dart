import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreferences {
// Hàm lưu trữ email
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    print('Email saved: $email');
  }

// Hàm lấy email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('userEmail'); // Trả về null nếu không có email được lưu
  }

// Hàm xóa email khi logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail'); // Xóa email đã lưu trong SharedPreferences
    print('User logged out. Email removed.');
  }
}
