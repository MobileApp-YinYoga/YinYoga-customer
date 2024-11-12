// Top genre DTO: numberOfClassInstances, genreName
class TopCourseDTO {
  final String courseId;
  final int numberOfClassInstances;
  final String courseName;
  final String imageUrl;

  TopCourseDTO({
    required this.courseId,
    required this.numberOfClassInstances,
    required this.courseName,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'numberOfClassInstances': numberOfClassInstances,
      'courseName': courseName,
      'imageUrl': imageUrl,
    };
  }

  factory TopCourseDTO.fromMap(Map<String, dynamic> map) {
    return TopCourseDTO(
      courseId: map['courseId'],
      numberOfClassInstances: map['numberOfClassInstances'],
      courseName: map['courseName'],
      imageUrl: map['imageUrl'],
    );
  }

}