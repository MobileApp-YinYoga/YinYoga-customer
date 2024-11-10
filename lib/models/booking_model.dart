class Booking {
  final String? id;
  final String instanceId; // Liên kết với `ClassInstance`
  final String email;
  final DateTime bookingDate;
  final String status; // e.g., 'confirmed', 'pending', 'cancelled'

  Booking({
    this.id,
    required this.instanceId,
    required this.email,
    required this.bookingDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'instanceId': instanceId,
      'email': email,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      instanceId: map['instanceId'],
      email: map['email'],
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'],
    );
  }
}
