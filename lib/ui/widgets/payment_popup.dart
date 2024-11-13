import 'package:flutter/material.dart';

class PaymentPopup extends StatelessWidget {
  final double totalPayment; // Tổng số tiền cần thanh toán

  PaymentPopup({required this.totalPayment});

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
                    // Thực hiện hành động thanh toán tại đây
                    print("Payment now button pressed");
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
}
