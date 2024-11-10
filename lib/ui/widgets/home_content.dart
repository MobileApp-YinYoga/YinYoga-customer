import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/repositories/course_repository.dart';
import 'package:yinyoga_customer/ui/widgets/search_homepage.dart';
import 'package:yinyoga_customer/ui/widgets/course_card.dart'; // Import the new widget

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final CourseRepository _courseRepository = CourseRepository();
  List<Course> _topCategories = [];
  List<Course> _newCourses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'courses name';

  final List<String> _filterOptions = [
    'courses name',
    'class instance',
    'category'
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Course> topCategories = await _courseRepository.fetchTopCategories();
      List<Course> newCourses = await _courseRepository.fetchNewCourses();
      setState(() {
        _topCategories = topCategories;
        _newCourses = newCourses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Dropdown Filter
            SearchHomePage(
              selectedFilter: _selectedFilter,
              onFilterChanged: (newFilter) {
                setState(() {
                  _selectedFilter = newFilter;
                });
              },
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 20),

            // Categories Section
            Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topCategories.map((course) {
                  return Container(
                    margin: EdgeInsets.only(right: 12.0),
                    width: 140,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/images/courses/${course.imageUrl}',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              course.courseName,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // New Courses Section
            const Text(
              'New Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: _newCourses.map((course) {
                return CourseCard(
                  course: course,
                  onAddToBooking: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${course.courseName} added to My Booking')),
                    );
                  },
                  onBookNow: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
