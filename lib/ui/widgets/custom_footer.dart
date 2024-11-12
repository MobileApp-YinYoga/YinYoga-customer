import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomFooter({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> regularIcons = [
      'assets/icons/navigations/courses.png',
      'assets/icons/navigations/booking.png',
      'assets/icons/navigations/home.png',
      'assets/icons/navigations/notifications.png',
      'assets/icons/navigations/help.png',
    ];

    final List<String> boldIcons = [
      'assets/icons/navigations/bold_courses.png',
      'assets/icons/navigations/bold_booking.png',
      'assets/icons/navigations/bold_home.png',
      'assets/icons/navigations/bold_notifications.png',
      'assets/icons/navigations/bold_help.png',
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: List.generate(regularIcons.length, (index) {
        return BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Column(
            children: [
              if (currentIndex == index)
                Container(
                  width: 26,
                  height: 2,
                  color: const Color(0xFF6D674B), // Màu thanh gạch lấy từ hình
                  margin: const EdgeInsets.only(top: 0),
                ),
              const SizedBox(height: 2),
              Image.asset(
                currentIndex == index ? boldIcons[index] : regularIcons[index],
                width: 24,
                height: 24,
              ),
            ],
          ),
          label: '',
        );
      }),
    );
  }
}
