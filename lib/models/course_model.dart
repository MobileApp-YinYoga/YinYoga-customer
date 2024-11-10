class Course {
  final String? id;
  final String courseName;
  final String imageUrl;
  final String dayOfWeek;
  final String time;
  final int capacity;
  final int duration;
  final double price;
  final String courseType;
  final DateTime createdAt; // Thêm thuộc tính createdAt

  Course({
    this.id,
    required this.courseName,
    required this.imageUrl,
    required this.dayOfWeek,
    required this.time,
    required this.capacity,
    required this.duration,
    required this.price,
    required this.courseType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'imageUrl': imageUrl,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'capacity': capacity,
      'duration': duration,
      'price': price,
      'courseType': courseType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      courseName: map['courseName'],
      imageUrl: map['imageUrl'],
      dayOfWeek: map['dayOfWeek'],
      time: map['time'],
      capacity: map['capacity'],
      duration: map['duration'],
      price: map['price'],
      courseType: map['courseType'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
