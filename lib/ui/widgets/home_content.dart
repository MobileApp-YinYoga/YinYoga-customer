import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/topCourseDTO.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/services/course_service.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final CourseService _courseService = CourseService();
  Future<List<TopCourseDTO>>? _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseService.getTopCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with image and search bar
            Stack(
              children: [
                // Background image container
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background/homepage.png'),
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
                // Search bar positioned at the bottom of the image
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0, // Slightly overlaps the next section
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
                            onChanged: (value) {
                              // Add your search logic here
                            },
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
                        GestureDetector(
                          onTap: () {
                            // Add clear functionality if needed
                          },
                          child: const Icon(Icons.close, color: Colors.grey, size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Padding to prevent overlap with the next section
            const SizedBox(height: 40),
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
            FutureBuilder<List<TopCourseDTO>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading courses'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No courses available'));
                } else {
                  List<TopCourseDTO> courses = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: courses.map((course) {
                          return _buildCourseCard(
                            course.courseId,
                            course.courseName,
                            course.imageUrl,
                            course.numberOfClassInstances > 1
                                ? '${course.numberOfClassInstances} classes'
                                : '${course.numberOfClassInstances} class',
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
                    _buildTipCard('Nutrition', 'assets/images/courses/nutrition.png'),
                    _buildTipCard('Weight Loss', 'assets/images/courses/weight_loss.png'),
                    _buildTipCard('Space', 'assets/images/courses/space.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(String courseId, String title, String imagePath, String classes) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      width: 270,
      height: 240,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/course-detail', arguments: courseId);
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/courses/$imagePath',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    classes,
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
                      title,
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
