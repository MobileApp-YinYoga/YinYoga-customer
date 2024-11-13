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
      // Fetch the courses, limiting to top 5 courses
      QuerySnapshot courseSnapshot =
          await _firestore.collection('courses').limit(5).get();

      List<TopCourseDTO> topCourses = [];

      // A map to hold the classType and its total booking count
      Map<String, int> classTypeBookingCount = {};

      // Fetch all class instances and related booking details
      for (var courseDoc in courseSnapshot.docs) {
        String courseId = courseDoc.id;
        String courseName = courseDoc['courseName'] ?? 'Unknown Course';
        String courseType = courseDoc['courseType'];

        // Fetch class instances for the current course
        QuerySnapshot classInstanceSnapshot = await _firestore
            .collection('classInstances')
            .where('courseId', isEqualTo: courseId)
            .get();

        for (var classInstanceDoc in classInstanceSnapshot.docs) {
          String classInstanceId = classInstanceDoc['instanceId'];

          // Count bookings for this class instance
          QuerySnapshot bookingDetailSnapshot = await _firestore
              .collection('bookingDetails')
              .where('instanceId', isEqualTo: classInstanceId)
              .get();

          int totalBookings = bookingDetailSnapshot.size;

          // Add to classTypeBookingCount map
          if (classTypeBookingCount.containsKey(courseType)) {
            classTypeBookingCount[courseType] =
                classTypeBookingCount[courseType]! + totalBookings;
          } else {
            classTypeBookingCount[courseType] = totalBookings;
          }
        }
      }

      // Sort class types by total bookings (descending order)
      var sortedClassTypes = classTypeBookingCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Get the top 5 class types
      List<String> topClassTypes =
          sortedClassTypes.take(5).map((entry) => entry.key).toList();

      // Prepare the DTO objects for the top courses
      for (var classType in topClassTypes) {
        // Fetch courses for this classType
        QuerySnapshot courseSnapshot = await _firestore
            .collection('courses')
            .where('courseType', isEqualTo: classType)
            .limit(
                5) // Assuming each classType will only have one representative course
            .get();

        for (var courseDoc in courseSnapshot.docs) {
          String courseId = courseDoc.id;
          String courseName = courseDoc['courseName'] ?? 'Unknown Course';
          String imageUrl =
              "category_default.png"; // Default image if not found

          // Handle imageUrl based on course type (added default image handling)
          if (classType != null && classType.isNotEmpty) {
            String formattedClassType =
                classType.toLowerCase().replaceAll(' ', '_');
            imageUrl = "$formattedClassType.png";
          }

          TopCourseDTO topCourse = TopCourseDTO(
            courseId: courseId,
            courseName: courseName,
            imageUrl: imageUrl,
            numberOfClassInstances: classTypeBookingCount[classType]!,
            classType: classType,
          );

          topCourses.add(topCourse);
        }
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
