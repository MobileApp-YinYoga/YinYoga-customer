import 'package:yinyoga_customer/dto/bookingDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/repositories/booking_repository.dart';

class BookingService {
  final BookingRepository _bookingRepository = BookingRepository();

  Future<void> createBooking(Booking booking, List<BookingDetail> bookingDetails) async {
    await _bookingRepository.addBooking(booking, bookingDetails);
  }

  Future<List<BookingDTO>> fetchBookingsByEmail(String email) async {
    return await _bookingRepository.getBookingsByEmail(email);
  }
}
