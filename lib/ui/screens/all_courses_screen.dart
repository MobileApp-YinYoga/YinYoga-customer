import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/course_model.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/services/course_service.dart';
import 'package:yinyoga_customer/ui/screens/course_detail_screen.dart';
import 'dart:convert';
import 'dart:typed_data';

class AllCoursesScreen extends StatefulWidget {
  String title; // Đảm bảo truyền vào title

  AllCoursesScreen({required this.title});

  @override
  _AllCoursesScreenState createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final CourseService _courseService = CourseService();
  final CartService _cartService = CartService();
  Future<List<Course>>? _coursesFuture;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;
  final List<String> _filterOptions = [
    'Class instance: A - Z',
    'Class instance: Z - A',
    'Price: Low to High',
    'Price: High to Low',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Uint8List _base64Decode(String source) {
    String cleanBase64 = source.contains(',') ? source.split(',').last : source;
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
    Uint8List imageBytes = base64Decode(cleanBase64);
    return imageBytes;
  }

  void _fetchCourses() {
    setState(() {
      if (widget.title == "All courses") {
        // Fetch all courses (or top courses)
        _coursesFuture = _courseService.getAllCourses();
      } else {
        // Fetch courses filtered by category (e.g., Category 1)
        _coursesFuture = _courseService.getCoursesByCategory(widget.title);
        // Set the selected filter to category name
        _selectedFilter = widget.title;

        widget.title = "Related courses";
      }
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _applyFilter(String option) {
    setState(() {
      _selectedFilter = option;
    });
  }

  void _clearFilter() {
    setState(() {
      _selectedFilter = null;
      widget.title == "All courses";
      _coursesFuture = _courseService.getAllCourses();
    });
  }

  List<Course> _filterAndSearchCourses(List<Course> courses) {
    // Apply search filtering
    List<Course> filteredCourses = courses.where((course) {
      return _searchQuery.isEmpty ||
          course.courseName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Apply sorting based on selected filter
    switch (_selectedFilter) {
      case 'Course: A - Z':
        filteredCourses.sort((a, b) =>
            a.courseName.toLowerCase().compareTo(b.courseName.toLowerCase()));
        break;
      case 'Course: Z - A':
        filteredCourses.sort((a, b) =>
            b.courseName.toLowerCase().compareTo(a.courseName.toLowerCase()));
        break;
      case 'Price: Low to High':
        filteredCourses.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filteredCourses.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return filteredCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _buildSearchBar(context),
            ),
            if (_selectedFilter != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: _clearFilter,
                  child: Chip(
                    label: Text(
                      _selectedFilter!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(0xFF6D674B),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onDeleted: _clearFilter,
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading courses'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No courses available'));
                  } else {
                    List<Course> courses =
                        _filterAndSearchCourses(snapshot.data!);

                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return _buildCourseCard(courses[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF6D674B)),
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
                      hintText: 'Search for course name...',
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
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            _showCustomDropdown(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune,
              color: Color(0xFF6D674B),
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomDropdown(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 100,
        kToolbarHeight + 10,
        0,
        0,
      ),
      items: _filterOptions.map((option) {
        return PopupMenuItem<String>(
          value: option,
          child: GestureDetector(
            // sự kiện onclick
            onTap: () {
              _applyFilter(option);
              Navigator.pop(context);
            },
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Color(0xFF6D674B),
              ),
            ),
          ),
        );
      }).toList(),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Handle image tap action here (e.g., navigate to course details)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsScreen(course: course),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: course.imageUrl.isNotEmpty
                  ? Image.memory(
                      // base64Decode(course.imageUrl),
                      _base64Decode(course.imageUrl),
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
          ),
          // Positioned(
          //   top: 16,
          //   right: 16,
          //   child: IconButton(
          //     icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          //     onPressed: () {
          //       // Handle favorite action
          //       _cartService.addToCart(course.id!, 'trannq2003@gmail.com');
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  course.courseName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                Text(
                  course.courseType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${course.dayOfWeek} - ${course.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Duration: ${course.duration} minutes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Price: \$${course.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Members: ${course.capacity}/${course.capacity}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 16,
          //   right: 16,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Handle booking action
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white.withOpacity(0.8),
          //       foregroundColor: const Color(0xFF6D674B),
          //       shape: RoundedRectangleBorder(
          //         side: const BorderSide(color: Colors.white),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: const Text('Booking now'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
