import 'dart:convert';
import 'dart:typed_data';

class Course {
  final String? id; // Changed from int? to String?
  final String courseName;
  final String imageUrl;
  final String dayOfWeek;
  final String time;
  final int capacity;
  final int duration;
  final double price;
  final String courseType;
  final String description;
  final DateTime createdAt; // Added createdAt attribute

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
    required this.description,
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
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id, // Keep id as String
      courseName: map['courseName'],
      imageUrl: map['imageUrl'],
      dayOfWeek: map['dayOfWeek'],
      time: map['time'],
      capacity: map['capacity'],
      duration: map['duration'],
      price: map['price'],
      courseType: map['courseType'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Add an empty constructor
  Course.empty()
      : id = '',
        courseName = '',
        imageUrl = '',
        dayOfWeek = '',
        time = '',
        capacity = 0,
        duration = 0,
        price = 0.0,
        courseType = '',
        description = '',
        createdAt = DateTime.now();

  // Convert base64 to Uint8List for displaying image
  Uint8List get imageBytes => base64Decode(imageUrl);
}
