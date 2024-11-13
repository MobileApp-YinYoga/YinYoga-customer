class CartDTO {
  final String instanceId;
  final String courseName;
  final String date;
  final String time;
  final String teacher;
  final String imageUrl;
  double price;
  bool isEditing;
  bool isSelected;  

  CartDTO({
    required this.instanceId,
    required this.courseName,
    required this.date,
    required this.time,
    required this.teacher,
    required this.imageUrl,
    required this.price,
    this.isEditing = false,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'instanceId': instanceId,
      'courseName': courseName,
      'date': date,
      'time': time,
      'teacher': teacher,
      'imageUrl': imageUrl,
      'price': price,
      'isSelected': isSelected,
      'isEditing': isEditing,
    };
  }

  factory CartDTO.fromMap(Map<String, dynamic> map) {
    return CartDTO(
      instanceId: map['instanceId'],
      courseName: map['courseName'],
      date: map['date'],
      time: map['time'],
      teacher: map['teacher'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      isSelected: map['isSelected'],
      isEditing: map['isEditing'],
    );
  }
}
