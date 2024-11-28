import 'package:flutter/material.dart';
import 'package:yinyoga_customer/ui/screens/booking_cart.dart';
import 'package:yinyoga_customer/ui/screens/welcome_screen.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double imageHeight;

  const CustomHeader({Key? key, required this.title, this.imageHeight = 100.0})
      : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(imageHeight);
}

class _CustomHeaderState extends State<CustomHeader> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    // Get data from SharedPreferences
    fullName = await SharedPreferencesHelper.getData('fullName');
    // chỉ lấy name từ fullName
    List<String> nameParts = fullName!.split(' ');
    if (nameParts.isNotEmpty) {
      setState(() { 
        fullName = nameParts[nameParts.length - 1];  
      });
    }
    setState(() {}); // Update the UI once the data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false, // Disable default back button
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back, color: Colors.white),
      //   onPressed: () {
      //     Navigator.pop(context); // Navigate to the previous page
      //   },
      // ),
      flexibleSpace: Container(
        width: double.infinity,
        height: widget.imageHeight, // Use the height from the widget
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/instances/flow_yoga.png'),
            // Background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullName != null ? 'Hi, $fullName!' : 'Hi!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 26, // Đặt chiều cao mong muốn
                    child: ElevatedButton(
                      onPressed: () {
                        SharedPreferencesHelper.logout()
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
}
