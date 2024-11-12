import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/screens/booking_screen.dart';
import 'package:yinyoga_customer/ui/screens/notification_screen.dart';
import 'package:yinyoga_customer/ui/widgets/home_content.dart';
import 'all_courses_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AllCoursesScreen(),
    BookingScreen(userEmail: 'trannq2003@gmail.com'),
    HomeContent(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomFooter(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
