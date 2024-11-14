import 'package:yinyoga_customer/dto/bookingDetailDTO.dart';

class BookingDTO {
  final String id; // Booking ID
  final String email;
  final DateTime bookingDate;
  final String status;
  final double totalAmount;
  final List<BookingDetailDTO> bookingDetails;

  BookingDTO({
    required this.id,
    required this.email,
    required this.bookingDate,
    required this.status,
    required this.totalAmount,
    required this.bookingDetails,
  });
}


