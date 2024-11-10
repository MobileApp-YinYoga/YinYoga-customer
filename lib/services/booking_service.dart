import 'package:yinyoga_customer/repositories/booking_repository.dart';

class BookingService {
  final BookingRepository _bookingRepository = BookingRepository();

  Future<List<Map<String, dynamic>>> getUserBookings(String userEmail) async {
    return await _bookingRepository.fetchUserBookings(userEmail);
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    await _bookingRepository.addBooking(bookingData);
  }

  Future<void> modifyBooking(String bookingId, Map<String, dynamic> updatedData) async {
    await _bookingRepository.updateBooking(bookingId, updatedData);
  }

  Future<void> removeBooking(String bookingId) async {
    await _bookingRepository.deleteBooking(bookingId);
  }
}
