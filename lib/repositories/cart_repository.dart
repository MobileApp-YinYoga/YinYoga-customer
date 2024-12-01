import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/models/cart_model.dart';
import 'package:yinyoga_customer/models/class_instance_model.dart';
import 'package:yinyoga_customer/models/course_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CartDTO>> fetchUserBookings(String userEmail) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .where('email', isEqualTo: userEmail)
          .get();

      List<CartDTO> cartItems = [];

      List<String> instanceIds = snapshot.docs
          .map((doc) => doc['instanceId']
              .toString()) 
          .toList();

      for (var instanceId in instanceIds) {
        DocumentSnapshot classInstanceSnapshot =
            await _firestore.collection('classInstances').doc(instanceId).get();

        if (classInstanceSnapshot.exists) {
          dynamic courseId = classInstanceSnapshot['courseId'];
          String courseIdString =
              courseId.toString(); // Convert courseId to string

          DocumentSnapshot courseDoc =
              await _firestore.collection('courses').doc(courseIdString).get();

          if (courseDoc.exists) {
            var courseData = courseDoc.data() as Map<String, dynamic>;
            var classInstanceData =
                classInstanceSnapshot.data() as Map<String, dynamic>;

            // Add to cartItems list with detailed information
            cartItems.add(CartDTO(
              instanceId: instanceId,
              courseName: courseData['courseName'] ?? 'Unknown Course',
              date: classInstanceData['dates']?.toString() ??
                  'N/A', // Convert Firestore timestamp to String, if necessary
              time: courseData['time']?.toString() ?? 'N/A',
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
      print('Error fetching cart: $e');
      return []; // Return empty list in case of error
    }
  }

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
      //print email và instanceId để kiểm tra
      print('email: $email');
      print('instanceId: $instanceId');

      // Delete the cart by instanceId and email
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .where('instanceId', isEqualTo: instanceId)
          .where('email', isEqualTo: email)
          .get();

      // Loop through each document and delete
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        print("Cart deleted successfully.");
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
