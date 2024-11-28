class TopCategoryDTO {
  final String courseId;
  final int numberOfCourses;
  final String courseName;
  final String classType;
  final String imageUrl;

  TopCategoryDTO({
    required this.courseId,
    required this.numberOfCourses,
    required this.courseName,
    required this.classType,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'numberOfCourses': numberOfCourses,
      'courseName': courseName,
      'classType': classType,
      'imageUrl': imageUrl,
    };
  }

  factory TopCategoryDTO.fromMap(Map<String, dynamic> map) {
    return TopCategoryDTO(
      courseId: map['courseId'],
      numberOfCourses: map['numberOfCourses'],
      courseName: map['courseName'],
      classType: map['classType'],
      imageUrl: map['imageUrl'],
    );
  }
}