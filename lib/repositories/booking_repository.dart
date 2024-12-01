import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/dto/bookingDTO.dart';
import 'package:yinyoga_customer/dto/bookingDetailDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';

class BookingRepository {
  final _firestore = FirebaseFirestore.instance;
  Future<void> addBooking(
      Booking booking, List<BookingDetail> bookingDetails) async {
    try {
      DocumentReference bookingRef =
          await _firestore.collection('bookings').add({
        'email': booking.email,
        'bookingDate': booking.bookingDate.toIso8601String(),
        'status': booking.status,
        'totalAmount': booking.totalAmount,
      });

      String bookingId = bookingRef.id;

      for (var detail in bookingDetails) {
        await _firestore.collection('bookingDetails').add({
          'bookingId': bookingId,
          'instanceId': detail.instanceId,
          'price': detail.price,
        });
      }
    } catch (e) {
      print('Error adding booking: $e');
    }
  }

  Future<List<BookingDTO>> getBookingsByEmail(String email) async {
    try {
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('email', isEqualTo: email)
          .get();

      List<BookingDTO> bookings = [];

      for (var doc in bookingSnapshot.docs) {
        Map<String, dynamic> bookingData =
            doc.data() as Map<String, dynamic>? ?? {};
        String bookingId = doc.id;

        String bookingEmail = bookingData['email'] ?? 'Unknown';
        String bookingStatus = bookingData['status'] ?? 'Pending';
        DateTime bookingDate = bookingData['bookingDate'] != null
            ? DateTime.tryParse(bookingData['bookingDate']) ?? DateTime.now()
            : DateTime.now();
        double totalAmount = bookingData['totalAmount']?.toDouble() ?? 0.0;

        QuerySnapshot bookingDetailSnapshot = await _firestore
            .collection('bookingDetails')
            .where('bookingId', isEqualTo: bookingId)
            .get();

        List<BookingDetailDTO> bookingDetails = [];

        for (var detailDoc in bookingDetailSnapshot.docs) {
          Map<String, dynamic> detailData =
              detailDoc.data() as Map<String, dynamic>? ?? {};

          String? instanceId = detailData['instanceId'];
          if (instanceId != null) {
            DocumentSnapshot instanceDoc = await _firestore
                .collection('classInstances')
                .doc(instanceId)
                .get();

            if (instanceDoc.exists) {
              Map<String, dynamic> instanceData =
                  instanceDoc.data() as Map<String, dynamic>? ?? {};

              ClassInstance instance = ClassInstance(
                id: instanceId,
                courseId: instanceData['courseId'] ??
                    0, // Provide default or handle null
                date: instanceData['dates'] != null
                    ? DateTime.tryParse(instanceData['dates']) ?? DateTime.now()
                    : DateTime.now(),
                teacher: instanceData['teacher'] ?? 'Unknown',
                imageUrl: instanceData['imageUrl'] ?? 'default_image.png',
              );

              BookingDetailDTO bookingDetail = BookingDetailDTO(
                id: detailDoc.id,
                instance: instance,
                price: detailData['price']?.toDouble() ??
                    0.0, // Ensure price is a double
              );

              bookingDetails.add(bookingDetail);
            }
          } else {
            print(
                'Skipping booking detail with null instanceId: ${detailDoc.id}');
          }
        }

        BookingDTO bookingDTO = BookingDTO(
          id: bookingId,
          email: bookingEmail,
          bookingDate: bookingDate,
          status: bookingStatus,
          totalAmount: totalAmount,
          bookingDetails: bookingDetails,
        );

        bookings.add(bookingDTO);
      }

      return bookings;
    } catch (e) {
      print('Error fetching bookings by email as DTO: $e');
      return [];
    }
  }
}
