class BookingDetail {
  final String? id;
  final String bookingId; // Liên kết với Booking
  final String instanceId; // Liên kết với ClassInstance
  final double price; // Giá của lớp học

  // Constructor
  BookingDetail({
    this.id,
    required this.bookingId,
    required this.instanceId,
    required this.price,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'instanceId': instanceId,
      'price': price,
    };
  }

  // Convert from Map
  factory BookingDetail.fromMap(Map<String, dynamic> map, String id) {
    return BookingDetail(
      id: id,
      bookingId: map['bookingId'],
      instanceId: map['instanceId'],
      price: map['price'],
    );
  }
}
