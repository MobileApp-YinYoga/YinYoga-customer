import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.jpg'), // Thay bằng đường dẫn hình của bạn
              radius: 16,
            ),
            SizedBox(width: 8),
            Text('Welcome to Yinyoga!'),
          ],
        ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
