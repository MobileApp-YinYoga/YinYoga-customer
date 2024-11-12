import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/dto/topCourseDTO.dart';
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

  Future<List<TopCourseDTO>> fetchTopCourses() async {
    try {
      // Fetch the courses ordered by their capacity (assuming this as popularity indicator)
      QuerySnapshot courseSnapshot = await _firestore
          .collection('courses')
          .orderBy('capacity', descending: true)
          .limit(5)
          .get();

      List<TopCourseDTO> topCourses = [];

      for (var courseDoc in courseSnapshot.docs) {
        // Extract course data
        String courseId = courseDoc.id;
        String courseName = courseDoc['courseName'] ?? 'Unknown Course';
        String imageUrl = courseDoc['imageUrl'] ?? ''; // Include imageUrl

        // Count associated ClassInstances for this course
        QuerySnapshot classInstanceSnapshot = await _firestore
            .collection('classInstances')
            .where('courseId', isEqualTo: courseId)
            .get();

        int numberOfClassInstances = classInstanceSnapshot.size;

        // Create DTO object
        TopCourseDTO topCourse = TopCourseDTO(
          courseId: courseId,
          courseName: courseName,
          imageUrl: imageUrl,
          numberOfClassInstances: numberOfClassInstances,
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
}
