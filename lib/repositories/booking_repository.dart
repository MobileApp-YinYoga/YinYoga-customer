import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserBookings(String userEmail) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('email', isEqualTo: userEmail)
          .get();

      return snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id // Adding document ID if needed
              })
          .toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  Future<void> addBooking(Map<String, dynamic> bookingData) async {
    try {
      await _firestore.collection('bookings').add(bookingData);
    } catch (e) {
      print('Error adding booking: $e');
    }
  }

  Future<void> updateBooking(String bookingId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update(updatedData);
    } catch (e) {
      print('Error updating booking: $e');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }
}
