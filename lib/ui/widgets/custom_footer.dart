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
      onTap: (index) => onTap(index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 5, // Đổ bóng cho thanh điều hướng
      selectedFontSize: 0, // Xóa bỏ font size của label
      unselectedFontSize: 0,
      items: List.generate(regularIcons.length, (index) {
        return BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              // Icon hiển thị hình ảnh
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  currentIndex == index ? boldIcons[index] : regularIcons[index],
                  width: 24,
                  height: 24,
                ),
              ),
              // Thanh ngang phía trên
              if (currentIndex == index)
                Positioned(
                  top: 0, // Thanh ngang nằm sát phía trên icon
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    width: double.infinity,
                    color: const Color(0xFF6D674B), // Màu gạch
                  ),
                ),
            ],
          ),
          label: '', // Xóa bỏ label của BottomNavigationBarItem
        );
      }),
    );
  }
}
