class Booking {
  final String? id;
  final String email;
  final DateTime bookingDate;
  final String status; 
  final double totalAmount; 

  Booking({
    this.id,
    required this.email,
    required this.bookingDate,
    required this.status,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      email: map['email'],
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'],
      totalAmount: map['totalAmount'],
    );
  }
}
