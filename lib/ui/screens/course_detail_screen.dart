import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/services/class_instance.dart';
import 'package:yinyoga_customer/ui/screens/booking_cart.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_success.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  CourseDetailsScreen({required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final ClassInstanceService _classInstances = ClassInstanceService();
  final CartService _cartService = CartService();
  late Future<List<ClassInstance>> _classInstancesFuture;

  @override
  void initState() {
    super.initState();
    _fetchClassInstances(); // Fetch class instances when the screen is loaded
  }

  void _fetchClassInstances() {
    _classInstancesFuture =
        _classInstances.getInstancesByCourseId(widget.course.id!);
  }

  Uint8List _base64Decode(String source) {
    String cleanBase64 = source.contains(',') ? source.split(',').last : source;
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
    Uint8List imageBytes = base64Decode(cleanBase64);
    return imageBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Remove default shadow to create a clean line appearance
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: const Color(0xFF6D674B), // Line color
            width: 50,
            height: 1.0, // Line thickness
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Banner
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.course.imageUrl.isNotEmpty
                        ? Image.memory(
                            _base64Decode(widget.course.imageUrl),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/courses/default_image.png', // Default image when base64 string is empty
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Corner radius 20
                      color: const Color(0xFF6D674B)
                          .withOpacity(0.3), // Fill 6D674B with opacity 40%
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.course.courseName,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Type: ${widget.course.courseType}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Date: ${widget.course.dayOfWeek} - ${widget.course.time}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Duration: ${widget.course.duration} minutes',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Price: \$${widget.course.price}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Members: ${widget.course.capacity}/${widget.course.capacity}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${widget.course.description}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF6D674B), thickness: 2),
              const SizedBox(height: 16),
              // Class Instances Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Class Instances',
                    style: TextStyle(
                      fontSize: 24, // Larger font size for main title
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF6D674B),
                    ),
                  ),
                  FutureBuilder<List<ClassInstance>>(
                    future: _classInstancesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No class instances available.'));
                      } else {
                        List<ClassInstance> classInstances = snapshot.data!;
                        return Column(
                          children: classInstances.map((classInstance) {
                            return _buildClassInstance(context, classInstance);
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassInstance(
      BuildContext context, ClassInstance classInstance) {
    // Kiểm tra null trước khi sử dụng
    final instanceId = classInstance.id ?? 'Unknown ID';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: classInstance.imageUrl.isNotEmpty
                ? Image.memory(
                    // base64Decode(course.imageUrl),
                    _base64Decode(classInstance.imageUrl),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/courses/default_image.png', // Default image when base64 string is empty
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Corner radius 20
              color: const Color(0xFF6D674B)
                  .withOpacity(0.3), // Fill 6D674B with opacity 40%
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              onPressed: () {
                // Handle favorite action
                try {
                  _cartService
                      .addToCart(classInstance.id!, 'trannq2003@gmail.com')
                      .then(
                    (value) {
                      if (value == 'Class added to cart successfully.' &&
                          value != 'Error') {
                        // CustomSuccessDialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomSuccessDialog(
                              title: 'Add to cart successfully',
                              content:
                                  'You have successfully booked this class instance.',
                              onConfirm: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingCartScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (value ==
                          'This class is already in your cart.') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomSuccessDialog(
                              title: 'Add to cart failed',
                              content: 'This class is already in your cart.',
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                } catch (e) {
                  debugPrint('Error: $e');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  instanceId!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Date: ${DateFormat('MMMM d, yyyy').format(classInstance.date)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Teacher: ${classInstance.teacher}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Handle booking action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.8),
                foregroundColor: const Color(0xFF6D674B),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Booking now'),
            ),
          ),
        ],
      ),
    );
  }
}
