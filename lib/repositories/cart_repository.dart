import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/models/cart_model.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';
import 'package:yinyoga_customer/models/course_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all bookings by user's email
  Future<List<CartDTO>> fetchUserBookings(String userEmail) async {
    try {
      // Fetch all carts (bookings) for the given user email
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .where('email', isEqualTo: userEmail)
          .get();

      // Loop through each cart document and map to CartDTO
      List<CartDTO> cartItems = [];

      // Collect all instanceIds from the carts for the user
      List<String> instanceIds =
          snapshot.docs.map((doc) => doc['instanceId'] as String).toList();

      for (var instanceId in instanceIds) {
        // Fetch classInstance details using the instanceId
        DocumentSnapshot classInstanceSnapshot =
            await _firestore.collection('classInstances').doc(instanceId).get();

        if (classInstanceSnapshot.exists) {
          String courseId = classInstanceSnapshot[
              'courseId']; // Get courseId from classInstance
          // Fetch course details using courseId
          DocumentSnapshot courseDoc =
              await _firestore.collection('courses').doc(courseId).get();

          if (courseDoc.exists) {
            var courseData = courseDoc.data() as Map<String, dynamic>;
            var classInstanceData =
                classInstanceSnapshot.data() as Map<String, dynamic>;

            // Add to cartItems list with detailed information
            cartItems.add(CartDTO(
              instanceId: instanceId,
              courseName: courseData['courseName'] ?? 'Unknown Course',
              date: classInstanceData['dates']?.toString() ??
                  'N/A', // Convert Firestore timestamp to Date
              time: courseData['time']?.toString() ??
                  'N/A', // Adjust to match your data format
              teacher: classInstanceData['teacher'] ?? 'N/A',
              imageUrl: classInstanceData['imageUrl'] ?? 'default_image.png',
              price: courseData['price']?.toDouble() ??
                  0.0, // Ensure price is a double
            ));
          }
        }
      }

      return cartItems;
    } catch (e) {
      print('Error fetching bookings: $e');
      return []; // Return empty list in case of error
    }
  }

  // Add a new booking to the cart
  Future<String> addToCart(String instanceId, String email) async {
    try {
      // check if the instanceId is already in the cart
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .where('instanceId', isEqualTo: instanceId)
          .where('email', isEqualTo: email)
          .get();

      // If the instanceId is already in the cart, return
      if (snapshot.docs.isNotEmpty) {
        return "This class is already in your cart.";
      } else {
        // Create a new Cart object
        Cart newCart = Cart(
          instanceId: instanceId,
          email: email,
          createdDate: DateTime.now(),
        );

        // Add to Firestore database
        await _firestore.collection('carts').add(newCart.toMap());
        return "Class added to cart successfully.";
      }
    } catch (e) {
      throw Exception("Error adding to booking cart: $e");
    }
  }

  // Update an existing booking
  Future<void> updateBooking(
      String bookingId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update(updatedData);
    } catch (e) {
      print('Error updating booking: $e');
    }
  }

  // Delete a cart by bookingId
  Future<void> deleteCartByInstanceId(String instanceId, String email) async {
    try {
      // Delete the cart by instanceId and email
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .where('instanceId', isEqualTo: instanceId)
          .where('email', isEqualTo: email)
          .get();

      // Loop through each document and delete
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  // Delete a cart by bookingId
  Future<void> deleteCart(String cartId) async {
    try {
      await _firestore.collection('carts').doc(cartId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }
}
