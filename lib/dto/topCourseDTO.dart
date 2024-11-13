class TopCourseDTO {
  final String courseId;
  final int numberOfClassInstances;
  final String courseName;
  final String classType;
  final String imageUrl;

  TopCourseDTO({
    required this.courseId,
    required this.numberOfClassInstances,
    required this.courseName,
    required this.classType,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'numberOfClassInstances': numberOfClassInstances,
      'courseName': courseName,
      'classType': classType,
      'imageUrl': imageUrl,
    };
  }

  factory TopCourseDTO.fromMap(Map<String, dynamic> map) {
    return TopCourseDTO(
      courseId: map['courseId'],
      numberOfClassInstances: map['numberOfClassInstances'],
      courseName: map['courseName'],
      classType: map['classType'],
      imageUrl: map['imageUrl'],
    );
  }
}