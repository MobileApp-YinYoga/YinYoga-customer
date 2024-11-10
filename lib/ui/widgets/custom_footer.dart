import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomFooter({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/home.png',
            width: 24,
            height: 24,
          ),
          label: '', // Không có nhãn
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/courses.png',
            width: 24,
            height: 24,
          ),
          label: '', // Không có nhãn
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/booking.png',
            width: 24,
            height: 24,
          ),
          label: '', // Không có nhãn
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/notifications.png',
            width: 24,
            height: 24,
          ),
          label: '', // Không có nhãn
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/profile.png',
            width: 24,
            height: 24,
          ),
          label: '', // Không có nhãn
        ),
      ],
    );
  }
}
