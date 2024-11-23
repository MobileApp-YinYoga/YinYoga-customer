import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print('Data saved: $value');
  }

  static Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key); // Returns null if no data is saved
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('User logged out.');
  }
}
