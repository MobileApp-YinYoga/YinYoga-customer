import 'package:flutter/material.dart';
import 'homepage_screen.dart'; // Thay bằng file của màn hình tiếp theo

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình ảnh nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_image.png', // Đường dẫn tới ảnh
              fit: BoxFit.cover, // Đảm bảo ảnh phủ đầy màn hình
            ),
          ),
          // Nội dung phía trên hình ảnh
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
                            builder: (context) => HomepageScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền của nút
                      foregroundColor: Colors.black, // Màu chữ
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                    ),
                    child: Text('Get Started'),
                  ),
                ),
                SizedBox(height: 50), // Khoảng cách giữa nút và cuối màn hình
              ],
            ),
          ),
        ],
      ),
    );
  }
}
