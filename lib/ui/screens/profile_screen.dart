import 'package:flutter/material.dart';
import 'package:yinyoga_customer/database/firestore_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_confirmation.dart';

class ProfileScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF6D674B),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: Color(0xFF6D674B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/background/welcome_image.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'SophiaRose',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Nguyen Que Tran',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'General',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D674B),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildButton(context, 'Edit Profile'),
                    _buildButton(context, 'Add Sample Data'),
                    _buildButton(context, 'Reset Database'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF6D674B),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        onPressed: () async {
          if (text == 'Reset Database') {
            showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmationDialog(
                title: 'Are you sure you want to reset the database?',
                content: "You won't be able to revert this!",
                onConfirm: () {
                  _firestoreService.deleteCollection('courses');
                  _firestoreService.deleteCollection('classInstances');
                  _firestoreService.deleteCollection('bookings');
                  Navigator.of(context).pop();
                },
              ),
            );
          } else if (text == 'Add Sample Data') {
            // Add sample courses
            List<String> courseIds = [];
            var courses = [
              {
                'courseName': 'Morning Meditation Yoga',
                'imageUrl': 'morning_yoga.jpg',
                'dayOfWeek': 'Monday',
                'time': '7:00 AM',
                'capacity': 30,
                'duration': 90,
                'price': 120.0,
                'courseType': 'Intermediate',
                'description': 'A gentle yoga class that focuses on meditation and relaxation. Suitable for beginners and intermediate practitioners.',
                'createdAt': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
              },
              {
                'courseName': 'Power Yoga for Strength',
                'imageUrl': 'power_yoga.jpg',
                'dayOfWeek': 'Wednesday',
                'time': '6:30 PM',
                'capacity': 25,
                'duration': 75,
                'price': 150.0,
                'courseType': 'Advanced',
                'description': 'A high-intensity yoga class that focuses on strength and flexibility. Suitable for advanced practitioners.',
                'createdAt': DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
              },
            ];
            for (var course in courses) {
              var docRef = await _firestoreService.createDocument('courses', course);
              courseIds.add(docRef.id); // Capture generated course ID
            }

            // Add sample class instances using courseIds
            _firestoreService.updateOrCreateCollection(
              'classInstances',
              [
                {
                  'instanceId': 'YOGA1001',
                  'courseId': courseIds.isNotEmpty ? courseIds[0] : '',
                  'dates': DateTime.now().add(Duration(days: 2)).toIso8601String(),
                  'teacher': 'Emma Johnson',
                  'imageUrl': 'energy_yoga.png',
                },
                {
                  'instanceId': 'YOGA1002',
                  'courseId': courseIds.length > 1 ? courseIds[1] : '',
                  'dates': DateTime.now().add(Duration(days: 5)).toIso8601String(),
                  'teacher': 'John Doe',
                  'imageUrl': 'hami_yoga.png',
                },
                {
                  'instanceId': 'YOGA1003',
                  'courseId': courseIds.isNotEmpty ? courseIds[0] : '',
                  'dates': DateTime.now().add(Duration(days: 7)).toIso8601String(),
                  'teacher': 'Emma Johnson',
                  'imageUrl': 'flow_yoga.png',
                }
              ],
            );

            // Add sample bookings
            _firestoreService.updateOrCreateCollection(
              'bookings',
              [
                {
                  'instanceId': 'YOGA1001',
                  'email': 'strawcy@gmail.com',
                  'bookingDate': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
                  'status': 'confirmed',
                },
                {
                  'instanceId': 'YOGA1002',
                  'email': 'trannq2003@gmail.com',
                  'bookingDate': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
                  'status': 'cancelled',
                },
              ],
            );

            // Add sample notifications for customers
            _firestoreService.updateOrCreateCollection(
              'notifications',
              [
                {
                  'title': 'New Course Available',
                  'email': 'trannq2003@gmail.com',
                  'description': 'Morning Meditation Yoga is now available for booking',
                  'time': DateTime.now().toIso8601String(),
                  'isRead': false,
                  'createdDate': DateTime.now().toIso8601String(),
                },
                {
                  'title': 'Booking Confirmed',
                  'email': 'trannq2003@gmail.com',
                  'description': 'Your booking for Power Yoga for Strength is confirmed',
                  'time': DateTime.now().toIso8601String(),
                  'isRead': false,
                  'createdDate': DateTime.now().toIso8601String(),
                },
              ],
            );
            
          } else {
            // Handle other actions
          }
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
