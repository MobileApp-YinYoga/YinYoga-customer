import 'package:yinyoga_customer/dto/topCourseDTO.dart';

import '../models/course_model.dart';
import '../repositories/course_repository.dart';

class CourseService {
  final CourseRepository _courseRepository = CourseRepository();

  // Method to add a new course
  Future<void> addCourse(Course course) async {
    await _courseRepository.addCourse(course);
  }

  // Method to fetch all courses
  Future<List<Course>> getAllCourses() async {
    return await _courseRepository.fetchAllCourses();
  }

  // Method to fetch top categories
  Future<List<TopCourseDTO>> getTopCourses() async {
    return await _courseRepository.fetchTopCourses();
  }

  // Method to fetch new courses
  Future<List<Course>> getNewCourses() async {
    return await _courseRepository.fetchNewCourses();
  }

  // Method to fetch course by ID
  Future<Course> getCourseById(String courseId) async {
    return await _courseRepository.fetchCourseById(courseId);
  }

  // Method to fetch course by ID
 Future<List<Course>> getCoursesByCategory(String classType) async {
    return await _courseRepository.fetchCourseByClassType(classType);
  }
}
