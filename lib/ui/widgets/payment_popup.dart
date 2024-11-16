import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/cartDTO.dart';
import 'package:yinyoga_customer/models/booking_detail.dart';
import 'package:yinyoga_customer/models/booking_model.dart';
import 'package:yinyoga_customer/models/notification_model.dart';
import 'package:yinyoga_customer/services/booking_service.dart';
import 'package:yinyoga_customer/services/cart_service.dart';
import 'package:yinyoga_customer/services/notification_service.dart';
import 'package:yinyoga_customer/ui/widgets/dialog_success.dart';
import 'package:yinyoga_customer/utils/otpService.dart';

class PaymentPopup extends StatelessWidget {
  final BookingService _bookingService = BookingService();
  final NotificationService _notification = NotificationService();
  final CartService _cartService = CartService();
  final double totalPayment;
  final List<CartDTO> bookingItems;
  final VoidCallback
      onSuccess; // Callback to notify parent of successful payment

  PaymentPopup(
      {required this.totalPayment,
      required this.bookingItems,
      required this.onSuccess});

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

  void _processPayment(BuildContext context) async {
    try {
      if (bookingItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No items selected for payment')),
        );
        return;
      }

      String userEmail =
          "trannq2003@gmail.com"; // Thay bằng email của người dùng
      DateTime bookingDate = DateTime.now();
      String status = 'pending'; // Mặc định là pending
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

      // Gọi hàm gửi email thông báo đăng ký thành công
      MailgunService mailgunService = MailgunService();
      String courseName = "Yoga Course"; // Tên khóa học
      await mailgunService.sendRegistrationSuccessEmail(userEmail, courseName);

      //Lưu vào notification
      NotificationModel notification = NotificationModel(
        id: DateTime.now().toIso8601String(),
        email: userEmail,
        title: 'Booking Successful',
        description:
            'You have successfully registered for $courseName. Your registration is pending approval.',
        time: DateTime.now().toString(),
        isRead: false,
        createdDate: DateTime.now().toIso8601String(),
      );

      _notification.addNotification(notification);

      showDialog(
        context: context,
        builder: (BuildContext context) => CustomSuccessDialog(
          title: "Payment Successful",
          content: "Check your email for confirmation",
          onConfirm: () {
            Navigator.of(context).pop();
          },
        ),
      );

      onSuccess(); // Notify parent of successful payment
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during payment: $e')),
      );
    }
  }
}
