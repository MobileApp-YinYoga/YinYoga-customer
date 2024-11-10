import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/repositories/course_repository.dart';
import 'package:yinyoga_customer/ui/widgets/course_card.dart';

class AllCoursesScreen extends StatefulWidget {
  @override
  _AllCoursesScreenState createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  List<Course> _allCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllCourses();
  }

  Future<void> _fetchAllCourses() async {
    try {
      List<Course> courses = await _courseRepository.fetchAllCourses();
      setState(() {
        _allCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch courses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allCourses.isEmpty
              ? const Center(
                  child: Text('No courses available'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _allCourses.length,
                  itemBuilder: (context, index) {
                    final course = _allCourses[index];
                    return CourseCard(
                      course: course,
                      onAddToBooking: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${course.courseName} added to My Booking')),
                        );
                      },
                      onBookNow: () {
                        Navigator.pushNamed(context, '/checkout');
                      },
                    );
                  },
                ),
    );
  }
}
