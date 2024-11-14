import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/services/booking_service.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_success.dart';

class PaymentPopup extends StatelessWidget {
  final BookingService _bookingService = BookingService();
  final CartService _cartService = CartService();
  final double totalPayment;
  final List<CartDTO> bookingItems;
  final VoidCallback onSuccess; // Callback to notify parent of successful payment

  PaymentPopup({required this.totalPayment, required this.bookingItems, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2), // Shadow position
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color(0xFF6D674B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalPayment Dollars',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFF6D674B),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _processPayment(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D674B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Payment Now',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) async {
    try {
      if (bookingItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No items selected for payment')),
        );
        return;
      }

      String userEmail = "trannq2003@gmail.com"; // Replace with actual user email
      DateTime bookingDate = DateTime.now();
      String status = 'pending'; // Default status
      double totalAmount = totalPayment;

      Booking booking = Booking(
        id: null,
        email: userEmail,
        bookingDate: bookingDate,
        status: status,
        totalAmount: totalAmount,
      );

      List<BookingDetail> bookingDetails = bookingItems.map((cartItem) {
        return BookingDetail(
          id: null,
          bookingId: '',
          instanceId: cartItem.instanceId,
          price: cartItem.price,
        );
      }).toList();

      await _bookingService.createBooking(booking, bookingDetails);

      for (var cartItem in bookingItems) {
        await _cartService.removeCartByInstanceId(cartItem.instanceId, userEmail);
      }

      onSuccess(); // Notify parent of successful payment

      showDialog(
        context: context,
        builder: (BuildContext context) => CustomSuccessDialog(
          title: "Payment Successful",
          content: "Your booking has been created successfully!",
          onConfirm: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during payment: $e')),
      );
    }
  }
}
