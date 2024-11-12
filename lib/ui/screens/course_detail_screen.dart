import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/services/class_instance.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  CourseDetailsScreen({required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final ClassInstanceService _classInstances = ClassInstanceService();
  late Future<List<ClassInstance>> _classInstancesFuture;

  @override
  void initState() {
    super.initState();
    _fetchClassInstances(); // Fetch class instances when the screen is loaded
  }

  void _fetchClassInstances() {
    _classInstancesFuture = _classInstances.getInstancesByCourseId(widget.course.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6D674B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.course.courseName,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/courses/${widget.course.imageUrl}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Course details
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
                        return const Center(child: Text('No class instances available.'));
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

  Widget _buildClassInstance(BuildContext context, ClassInstance classInstance) {
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
            child: Image.asset(
              'assets/images/instances/${classInstance.imageUrl}',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  classInstance.instanceId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Date: ${DateFormat('MMMM d, yyyy').format(classInstance.dates)}',
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

