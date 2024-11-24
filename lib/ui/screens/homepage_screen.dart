import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/screens/booking_screen.dart';
import 'package:yinyoga_customer/ui/screens/notification_screen.dart';
import 'package:yinyoga_customer/ui/widgets/home_content.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';
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
  int _selectedIndex = 2;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    // Load data from SharedPreferences
    String email = (await SharedPreferencesHelper.getData('email'))!;
    String fullName = (await SharedPreferencesHelper.getData('fullName'))!;

    // Initialize `_pages` after `email` is loaded
    setState(() {
      _pages = [
        AllCoursesScreen(title: 'All courses'),
        BookingScreen(userEmail: email),
        HomeContent(fullName: fullName),
        NotificationsScreen(),
        ProfileScreen(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator until `_pages` is initialized
    if (_pages == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: _selectedIndex != 2 ? CustomHeader(title: 'Home page') : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomFooter(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
