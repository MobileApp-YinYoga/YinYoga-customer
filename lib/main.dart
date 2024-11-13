import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yinyoga_customer/ui/screens/booking_cart.dart';
import 'package:yinyoga_customer/ui/screens/homepage_screen.dart';
import 'package:yinyoga_customer/ui/screens/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase đã được khởi tạo thành công.');
  } catch (e) {
    print('Lỗi khi khởi tạo Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoga Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomepageScreen(),
      // home: BookingCartScreen(),
    );
  }
}
