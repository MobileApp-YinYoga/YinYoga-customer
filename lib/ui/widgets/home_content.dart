import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/topCategoryDTO.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/services/course_service.dart';
import 'package:yinyoga_customer/ui/screens/all_courses_screen.dart';
import 'package:yinyoga_customer/ui/screens/course_detail_screen.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final CourseService _courseService = CourseService();
  Future<List<TopCategoryDTO>>? _coursesFuture;
  List<TopCategoryDTO> _courses = [];
  List<TopCategoryDTO> _filteredCourses = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTopCourses();
  }

  void _fetchTopCourses() {
    _coursesFuture = _courseService.getTopCourses();
    _coursesFuture!.then((courses) {
      setState(() {
        _courses = courses;
        _filteredCourses = courses;
      });
    }).catchError((error) {
      print('Error fetching courses: $error');
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredCourses = _courses; // Reset to original list if query is empty
      } else {
        _filteredCourses = _courses
            .where((course) => course.courseName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section with image and search bar
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/background/homepage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Liza!',
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'What type of yoga do you want to practice today?',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding to create space for overlayed search bar
                const SizedBox(height: 20),
                // Category Yoga Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Category Yoga',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF6D674B),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<List<TopCategoryDTO>>(
                  future: _coursesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading courses'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No courses available'));
                    } else {
                      List<TopCategoryDTO> courses = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: courses.map((course) {
                              return _buildCourseCard(
                                course.courseId,
                                course.classType,
                                course.imageUrl,
                                course.numberOfCourses > 1
                                    ? '${course.numberOfCourses} courses'
                                    : '${course.numberOfCourses} course',
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                // Healthy Tips Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Healthy Tips',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF6D674B),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTipCard(
                            'Nutrition', 'assets/images/courses/nutrition.png'),
                        _buildTipCard('Weight Loss',
                            'assets/images/courses/weight_loss.png'),
                        _buildTipCard(
                            'Space', 'assets/images/courses/space.png'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search bar overlayed
          Positioned(
            left: 20,
            right: 20,
            top: 180, // Adjust based on where you want it to appear
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF6D674B),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _handleSearch,
                      decoration: InputDecoration(
                        hintText: 'Search for classes',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _handleSearch(''); // Reset search
                      },
                      child:
                          const Icon(Icons.close, color: Colors.grey, size: 24),
                    ),
                ],
              ),
            ),
          ),
          // Search results display below the bar
          if (_searchQuery.isNotEmpty)
            Positioned(
              left: 20,
              right: 20,
              top: 240, // Position results below the search bar
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF6D674B)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _filteredCourses.isNotEmpty
                    ? Column(
                        children: _filteredCourses.map((course) {
                          return FutureBuilder<Course>(
                            future: _courseService.getCourseById(
                                course.courseId), // Fetch course asynchronously
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Show a loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                final getCourse = snapshot
                                    .data!; // Get the course from the snapshot

                                return ListTile(
                                  title: Text(getCourse
                                      .courseName), // Use the fetched course name
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CourseDetailsScreen(
                                            course:
                                                getCourse), // Pass course details
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Text('No course data available');
                              }
                            },
                          );
                        }).toList(),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Not found this course name',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.red,
                          ),
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      String courseId, String classType, String imagePath, String numberOfClasses) {
    return FutureBuilder<Course>(
      future: _courseService
          .getCourseById(courseId), // Fetch the course data asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, show a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error fetching the course, display an error message
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // If no course data is returned, display a placeholder
          return const Text('Course not available');
        } else {
          // Once the course data is fetched, build the card
          final course = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 270,
            height: 240,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCoursesScreen(title: classType),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/categories/$imagePath',
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          numberOfClasses,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'Poppins',
                            color: Color(0xFF6D674B),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: Text(
                            classType,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTipCard(String title, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      width: 160,
      height: 140,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
