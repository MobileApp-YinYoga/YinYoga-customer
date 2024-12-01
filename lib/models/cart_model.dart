class Cart {
  final String? id;
  final String instanceId; 
  final String email;
  final DateTime createdDate;

  Cart({
    this.id,
    required this.instanceId,
    required this.email,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'instanceId': instanceId,
      'email': email,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map, String id) {
    return Cart(
      id: id,
      instanceId: map['instanceId'],
      email: map['email'],
      createdDate: DateTime.parse(map['createdDate']),
    );
  }
}
