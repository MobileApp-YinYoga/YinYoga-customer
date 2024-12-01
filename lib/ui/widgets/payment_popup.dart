import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/models/notification_model.dart';
import 'package:yinyoga_customer/services/booking_service.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/services/notification_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_confirmation.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_success.dart';
import 'package:yinyoga_customer/utils/mailService.dart';
import 'package:yinyoga_customer/utils/sharedPreferences.dart';

class PaymentPopup extends StatelessWidget {
  final BookingService _bookingService = BookingService();
  final NotificationService _notification = NotificationService();
  final CartService _cartService = CartService();
  final double totalPayment;
  final List<CartDTO> bookingItems;
  final VoidCallback
      onSuccess; // Callback to notify parent of successful payment

  PaymentPopup({
    required this.totalPayment,
    required this.bookingItems,
    required this.onSuccess,
  });

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
                  offset: const Offset(0, -2), // Shadow position
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
                    _confirmPayment(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D674B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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

  void _confirmPayment(BuildContext context) {
    String className = bookingItems.isNotEmpty
        ? bookingItems.map((cartItem) => cartItem.instanceId).join('", "')
        : 'Unknown Class';

    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: 'Are you sure to payment now?',
        content: "You are about to pay for the following classes: $className.",
        onConfirm: () {
          _processPayment(context);
        },
      ),
    );
  }

  void _processPayment(BuildContext context) async {
    try {
      if (bookingItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No items selected for payment')),
        );
        return;
      }

      // Show loading indicator while processing payment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(), // Show loading spinner
          );
        },
      );

      String userEmail = (await SharedPreferencesHelper.getData('email'))!;
      DateTime bookingDate = DateTime.now();
      String status = 'pending'; // Default status is pending
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
        await _cartService.removeCartByInstanceId(
            cartItem.instanceId, userEmail);
      }

      // Get class names for email
      String className = bookingItems.isNotEmpty
          ? bookingItems.map((cartItem) => cartItem.instanceId).join('", "')
          : '';

      // Send email after successful booking
      MailService mailgunService = MailService();
      await mailgunService.sendRegistrationSuccessEmail(userEmail, className);

      // Create notification for admin
      NotificationModel notification = NotificationModel(
        email: "",
        title: 'Booking Successful',
        description:
            "User $userEmail has booked a class for $className at ${DateFormat('dd/MM/yyyy HH:mm').format(bookingDate)}.",
        time: DateTime.now().toString(),
        isRead: false,
        createdDate: DateTime.now().toIso8601String(),
      );

      _notification.addNotification(notification);

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomSuccessDialog(
          title: "Payment Successful",
          content: "Check your email for confirmation",
          onConfirm: () {
            Navigator.of(context).pop();
            // Navigate to my bookings page
            Navigator.of(context).pushNamed('/my-bookings');
          },
        ),
      );

      // Notify parent widget that payment is successful
      onSuccess();
    } catch (e) {
      // Close loading dialog in case of error
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during payment: $e')),
      );
    }
  }
}
