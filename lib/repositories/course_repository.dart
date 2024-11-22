import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yinyoga_customer/dto/topCategoryDTO.dart';
import '../models/course_model.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCourse(Course course) async {
    try {
      await _firestore.collection('courses').add(course.toMap());
      print('Course added successfully');
    } catch (e) {
      print('Error adding course: $e');
    }
  }

  Future<String> saveImageToFile(Uint8List imageBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    final imagePath = '${directory.path}/$fileName';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);
    return imagePath;
  }

  Future<List<Course>> fetchAllCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();

      List<Course> courses = snapshot.docs.map((doc) {
        // Tạo đối tượng Course từ dữ liệu Firestore
        final course =
            Course.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        // Nếu có dữ liệu base64, giải mã và lưu hình ảnh
        // if (course.imageUrl.isNotEmpty) {
        //   String cleanBase64 = course.imageUrl.contains(',')
        //       ? course.imageUrl.split(',').last
        //       : course.imageUrl;
        //   cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
        //   Uint8List imageBytes = base64Decode(cleanBase64);
        //   print(imageBytes);
        // }

        return course;
      }).toList();

      return courses;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<List<TopCategoryDTO>> fetchTopCourses() async {
    try {
      // Fetch all courses
      QuerySnapshot courseSnapshot =
          await _firestore.collection('courses').get();

      List<TopCategoryDTO> topCourses = [];

      // Iterate through each course document and prepare DTO objects
      for (var courseDoc in courseSnapshot.docs) {
        String courseId = courseDoc.id;
        String courseName = courseDoc['courseName'] ?? 'Unknown Course';
        String courseType = courseDoc['courseType'] ?? 'Unknown Type';

        // Default image handling
        String imageUrl = "category_default.png"; // Default image if not found
        if (courseType.isNotEmpty) {
          String formattedClassType =
              courseType.toLowerCase().replaceAll(' ', '_');
          imageUrl = "$formattedClassType.png";
        }
        print("courseId: $courseId");

        //conver to int courseId
        int id = int.parse(courseId);
        // Count number of class instances associated with the course
        QuerySnapshot classInstanceSnapshot = await _firestore
            .collection('classInstances')
            .where('courseId', isEqualTo: id)
            .get();

        int numberOfClassInstances = classInstanceSnapshot.docs.length;

        // Create DTO object for the course
        TopCategoryDTO topCourse = TopCategoryDTO(
          courseId: courseId,
          courseName: courseName,
          imageUrl: imageUrl,
          numberOfClassInstances: numberOfClassInstances, // Updated count
          classType: courseType,
        );

        // Add the course to the list
        topCourses.add(topCourse);
      }

      return topCourses;
    } catch (e) {
      print('Error fetching top courses: $e');
      return [];
    }
  }

  Future<List<Course>> fetchNewCourses() async {
    try {
      // Lấy 5 khóa học mới nhất dựa trên `createdAt`
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .orderBy('createdAt',
              descending: true) // Sắp xếp theo ngày tạo mới nhất
          .limit(5)
          .get();

      return snapshot.docs
          .map((doc) =>
              Course.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching new courses: $e');
      return [];
    }
  }

  Future<Course> fetchCourseById(String courseId) async {
    try {
      DocumentSnapshot courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      return Course.fromMap(courseDoc.data() as Map<String, dynamic>, courseId);
    } catch (e) {
      print('Error fetching course by ID: $e');
      return Course.empty();
    }
  }

  Future<List<Course>> fetchCourseByClassType(String classType) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .where('courseType', isEqualTo: classType)
          .get();
      return snapshot.docs
          .map((doc) =>
              Course.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching courses by class type: $e');
      return [];
    }
  }
}
