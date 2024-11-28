import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/cart_model.dart';
import 'package:yinyoga_customer/ui/screens/booking_cart.dart';
import 'package:yinyoga_customer/ui/screens/welcome_screen.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double imageHeight;

  CustomHeader({required this.title, this.imageHeight = 100.0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        width: double.infinity,
        height: imageHeight, // Dynamic height based on the passed parameter
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/instances/flow_yoga.png'), // Background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, Liza!',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align buttons to the right
                children: [
                  SizedBox(
                    height: 26, // Đặt chiều cao mong muốn
                    child: ElevatedButton(
                      onPressed: () {
                        Sharedpreferences.logout()
                            .then((value) => Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomeScreen(),
                                  ),
                                ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingCartScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        backgroundColor:
                            Colors.transparent, 
                        shape: const CircleBorder(), 
                        side: BorderSide.none, 
                      ),
                      child: Image.asset(
                        'assets/icons/utils/cart.png',
                        ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(imageHeight); // Update height dynamically
}
