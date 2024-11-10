class NotificationModel {
  final int id;
  final String title;
  final String email;
  final String description;
  final String time;
  final bool isRead;
  final String createdDate;

  NotificationModel({
    required this.id,
    required this.title,
    required this.email,
    required this.description,
    required this.time,
    this.isRead = false,
    required this.createdDate,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? email,
    String? description,
    String? time,
    bool? isRead,
    String? createdDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      email: email ?? this.email,
      description: description ?? this.description,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'description': description,
      'time': time,
      'isRead': isRead ? 1 : 0,
      'createdDate': createdDate,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      email: map['email'],
      description: map['description'] ?? '',
      time: map['time'],
      isRead: map['isRead'] == 1,
      createdDate: map['createdDate'],
    );
  }
}
