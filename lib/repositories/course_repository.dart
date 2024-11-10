import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<Course>> fetchAllCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      return snapshot.docs
          .map((doc) =>
              Course.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<List<Course>> fetchTopCategories() async {
    try {
      // Lấy 5 khóa học phổ biến nhất (giả định theo sức chứa cao nhất)
      QuerySnapshot snapshot = await _firestore
          .collection('courses')
          .orderBy('capacity',
              descending: true) // Sắp xếp theo sức chứa (capacity) giảm dần
          .limit(5)
          .get();

      return snapshot.docs
          .map((doc) =>
              Course.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching top categories: $e');
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
}
