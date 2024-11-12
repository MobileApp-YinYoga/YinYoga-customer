class ClassInstance {
  final String instanceId;
  final String courseId; // Liên kết với `Course`
  final DateTime dates;
  final String teacher;
  final String imageUrl;

  ClassInstance({
    required this.instanceId,
    required this.courseId,
    required this.dates,
    required this.teacher,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'instanceId': instanceId,
      'courseId': courseId,
      'dates': dates.toIso8601String(),
      'teacher': teacher,
      'imageUrl': imageUrl,
    };
  }

  factory ClassInstance.fromMap(Map<String, dynamic> map) {
    return ClassInstance(
      instanceId: map['instanceId'],
      courseId: map['courseId'],
      dates: DateTime.parse(map['dates']),
      teacher: map['teacher'],
      imageUrl: map['imageUrl'],
    );
  }
}
