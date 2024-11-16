class ClassInstance {
  final String? id;
  final int courseId; // Liên kết với `Course`
  final DateTime date;
  final String teacher;
  final String imageUrl;

  ClassInstance({
    this.id,
    required this.courseId,
    required this.date,
    required this.teacher,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'date': date.toIso8601String(),
      'teacher': teacher,
      'imageUrl': imageUrl,
    };
  }

  factory ClassInstance.fromMap(Map<String, dynamic> map) {
    return ClassInstance(
      id: map['instanceId'],
      courseId: map['courseId'],
      date: DateTime.tryParse(map['date']) ??
          DateTime.now(), // Convert String to DateTime, with a fallback value
      teacher: map['teacher'],
      imageUrl: map['imageUrl'],
    );
  }
}
