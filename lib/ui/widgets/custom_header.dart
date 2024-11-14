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
      backgroundColor: Colors.transparent, // AppBar transparent
      elevation: 0, // No shadow on AppBar
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
                  ElevatedButton(
                    onPressed: () {
                      Sharedpreferences.logout().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingCartScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                  ),
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
