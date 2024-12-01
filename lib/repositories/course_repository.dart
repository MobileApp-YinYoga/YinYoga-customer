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
        final course =
            Course.fromMap(doc.data() as Map<String, dynamic>, doc.id);
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
      QuerySnapshot courseSnapshot =
          await _firestore.collection('courses').get();

      List<TopCategoryDTO> topCourses = [];

      for (var courseDoc in courseSnapshot.docs) {
        String courseId = courseDoc.id;
        String courseName = courseDoc['courseName'] ?? 'Unknown Course';
        String courseType = courseDoc['courseType'] ?? 'Unknown Type';

        String imageUrl = "category_default.png"; // Default image if not found
        if (courseType.isNotEmpty) {
          String formattedClassType =
              courseType.toLowerCase().replaceAll(' ', '_');
          imageUrl = "$formattedClassType.png";
        }

        QuerySnapshot coursesSnapshot = await _firestore
            .collection('courses')
            .where('courseType', isEqualTo: courseType)
            .get();

        print("Length: ${coursesSnapshot.docs.length}");

        int numberOfCourses = coursesSnapshot.docs.length;

        // Create DTO object for the course
        TopCategoryDTO topCourse = TopCategoryDTO(
          courseId: courseId,
          courseName: courseName,
          imageUrl: imageUrl,
          numberOfCourses: numberOfCourses, // Updated count
          classType: courseType,
        );

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
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .orderBy('createdAt',
              descending: true) 
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
