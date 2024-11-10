class ClassInstance {
  final String instanceId;
  final String courseId; // Liên kết với `Course`
  final DateTime dates;
  final String teacher;
  final String status;

  ClassInstance({
    required this.instanceId,
    required this.courseId,
    required this.dates,
    required this.teacher,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'instanceId': instanceId,
      'courseId': courseId,
      'dates': dates.toIso8601String(),
      'teacher': teacher,
      'status': status,
    };
  }

  factory ClassInstance.fromMap(Map<String, dynamic> map, String id) {
    return ClassInstance(
      instanceId: id,
      courseId: map['courseId'],
      dates: DateTime.parse(map['dates']),
      teacher: map['teacher'],
      status: map['status'],
    );
  }
}
