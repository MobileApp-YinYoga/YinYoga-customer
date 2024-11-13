class ClassInstance {
  final String? id;
  final String courseId; // Liên kết với `Course`
  final DateTime dates;
  final String teacher;
  final String imageUrl;

  ClassInstance({
    this.id,
    required this.courseId,
    required this.dates,
    required this.teacher,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'dates': dates.toIso8601String(),
      'teacher': teacher,
      'imageUrl': imageUrl,
    };
  }

  factory ClassInstance.fromMap(Map<String, dynamic> map) {
    return ClassInstance(
      id: map['id'],
      courseId: map['courseId'],
      dates: DateTime.parse(map['dates']),
      teacher: map['teacher'],
      imageUrl: map['imageUrl'],
    );
  }
}
