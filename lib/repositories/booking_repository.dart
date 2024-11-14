import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/dto/bookingDTO.dart';
import 'package:yinyoga_customer/dto/bookingDetailDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';

class BookingRepository {
  // Thay thế bằng logic kết nối cơ sở dữ liệu thực tế của bạn (ví dụ: Firebase, SQLite, v.v.)
  final _firestore = FirebaseFirestore.instance;
  Future<void> addBooking(
      Booking booking, List<BookingDetail> bookingDetails) async {
    try {
      // Thêm Booking vào Firestore
      DocumentReference bookingRef =
          await _firestore.collection('bookings').add({
        'email': booking.email,
        'bookingDate': booking.bookingDate.toIso8601String(),
        'status': booking.status,
        'totalAmount': booking.totalAmount,
      });

      // Lấy ID của Booking vừa được thêm
      String bookingId = bookingRef.id;

      // Thêm các BookingDetail liên quan
      for (var detail in bookingDetails) {
        await _firestore.collection('bookingDetails').add({
          'bookingId': bookingId,
          'instanceId': detail.instanceId,
          'price': detail.price,
        });
      }

      //updated capcity 
    } catch (e) {
      print('Error adding booking: $e');
    }
  }

  Future<List<BookingDTO>> getBookingsByEmail(String email) async {
    try {
      // Lấy danh sách Booking theo email
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('email', isEqualTo: email)
          .get();

      List<BookingDTO> bookings = [];

      for (var doc in bookingSnapshot.docs) {
        Map<String, dynamic> bookingData = doc.data() as Map<String, dynamic>;
        String bookingId = doc.id;

        // Lấy danh sách BookingDetail liên quan đến Booking này
        QuerySnapshot bookingDetailSnapshot = await _firestore
            .collection('bookingDetails')
            .where('bookingId', isEqualTo: bookingId)
            .get();

        List<BookingDetailDTO> bookingDetails = [];

        for (var detailDoc in bookingDetailSnapshot.docs) {
          Map<String, dynamic> detailData =
              detailDoc.data() as Map<String, dynamic>;

          // Lấy thông tin ClassInstance liên quan
          String instanceId = detailData['instanceId'];
          DocumentSnapshot instanceDoc = await _firestore
              .collection('classInstances')
              .doc(instanceId)
              .get();

          if (instanceDoc.exists) {
            Map<String, dynamic> instanceData =
                instanceDoc.data() as Map<String, dynamic>;

            // Tạo ClassInstance từ dữ liệu lấy được
            ClassInstance instance = ClassInstance(
              id: instanceId,
              // Gán các trường còn lại theo mô hình ClassInstance của bạn
              // Ví dụ:
              courseId: instanceData['courseId'],
              dates: DateTime.parse(instanceData['dates']),
              teacher: instanceData['teacher'],
              imageUrl: instanceData['imageUrl'],
            );

            // Tạo BookingDetailDTO từ dữ liệu lấy được
            BookingDetailDTO bookingDetail = BookingDetailDTO(
              id: detailDoc.id,
              instance: instance,
              price: detailData['price'],
            );

            bookingDetails.add(bookingDetail);
          }
        }

        // Tạo BookingDTO từ dữ liệu đã lấy
        BookingDTO bookingDTO = BookingDTO(
          id: bookingId,
          email: bookingData['email'],
          bookingDate: DateTime.parse(bookingData['bookingDate']),
          status: bookingData['status'],
          totalAmount: bookingData['totalAmount'],
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
