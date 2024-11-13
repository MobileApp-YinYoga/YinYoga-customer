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
              // Your header and UI code here
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
                  _firestoreService.deleteCollection('carts');
                  _firestoreService.deleteCollection('notifications');
                  _firestoreService.deleteCollection('bookings');
                  _firestoreService.deleteCollection('bookingDetails');
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
                'courseType': 'Kundalini Yoga',
                'description': 'A gentle yoga class focusing on relaxation.',
                'createdAt': DateTime.now()
                    .subtract(Duration(days: 30))
                    .toIso8601String(),
              },
              {
                'courseName': 'Power Yoga for Strength',
                'imageUrl': 'power_yoga.jpg',
                'dayOfWeek': 'Wednesday',
                'time': '6:30 PM',
                'capacity': 25,
                'duration': 75,
                'price': 150.0,
                'courseType': 'Kundalini Yoga',
                'description':
                    'A high-intensity yoga class focusing on strength.',
                'createdAt': DateTime.now()
                    .subtract(Duration(days: 15))
                    .toIso8601String(),
              },
            ];

            // Create courses and get their IDs
            for (var course in courses) {
              var docRef =
                  await _firestoreService.createDocument('courses', course);
              courseIds.add(docRef.id);
            }

            // Add sample class instances using courseIds
            var classInstances = [
              {
                'courseId': "1",
                'dates':
                    DateTime.now().add(Duration(days: 2)).toIso8601String(),
                'teacher': 'Emma Johnson',
                'imageUrl': 'energy_yoga.png',
              },
              {
                'courseId': "1",
                'dates':
                    DateTime.now().add(Duration(days: 5)).toIso8601String(),
                'teacher': 'John Doe',
                'imageUrl': 'hami_yoga.png',
              },
            ];

            // Create class instances
            List<String> classInstanceIds = [];
            for (var classInstance in classInstances) {
              var docRef = await _firestoreService.createDocument(
                  'classInstances', classInstance);
              classInstanceIds.add(docRef.id);
            }

            // Create a booking document
            var bookingRef =
                await _firestoreService.createDocument('bookings', {
              'email': 'trannq2003@gmail.com',
              'bookingDate': DateTime.now().toIso8601String(),
              'status': 'Confirmed',
              'totalAmount': 270.0,
            });

            // Create booking details with the bookingId
            var bookingDetails = [
              {
                'bookingId': bookingRef.id, // Link to the booking document
                'instanceId': classInstanceIds[0],
                'price': 120.0,
              },
              {
                'bookingId': bookingRef.id, // Link to the booking document
                'instanceId': classInstanceIds[1],
                'price': 150.0,
              },
            ];

            // Create booking details
            await _firestoreService.updateOrCreateCollection(
              'bookingDetails',
              bookingDetails,
            );

            // Add sample bookings for the customer
            _firestoreService.updateOrCreateCollection(
              'carts',
              [
                {
                  'instanceId': 'YOGA1001',
                  'email': 'trannq2003@gmail.com',
                  'createdDate': DateTime.now().toIso8601String(),
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
                  'description':
                      'Morning Meditation Yoga is now available for booking',
                  'time': DateTime.now().toIso8601String(),
                  'isRead': false,
                  'createdDate': DateTime.now().toIso8601String(),
                },
                {
                  'title': 'Booking Confirmed',
                  'email': 'trannq2003@gmail.com',
                  'description':
                      'Your booking for Power Yoga for Strength is confirmed',
                  'time': DateTime.now().toIso8601String(),
                  'isRead': false,
                  'createdDate': DateTime.now().toIso8601String(),
                },
              ],
            );

            // add cart 2 data
            _firestoreService.updateOrCreateCollection(
              'carts',
              [
                {
                  'instanceId': 'YOGA1002',
                  'email': 'trannq2003@gmail.com',
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
