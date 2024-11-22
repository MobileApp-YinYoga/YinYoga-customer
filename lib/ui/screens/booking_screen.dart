import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:yinyoga_customer/dto/bookingDTO.dart';
import 'package:yinyoga_customer/services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final String userEmail;

  BookingScreen({required this.userEmail});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

Uint8List _base64Decode(String source) {
  String cleanBase64 = source.contains(',') ? source.split(',').last : source;
  cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
  Uint8List imageBytes = base64Decode(cleanBase64);
  return imageBytes;
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService =
      BookingService(); // Initialize BookingService
  late Future<List<BookingDTO>> _bookingItemsFuture;
  bool _isExpanded = false;

  String userEmail = "trannq2003@gmail.com"; // Track if details are expanded

  @override
  void initState() {
    super.initState();
    _bookingItemsFuture = _bookingService.fetchBookingsByEmail(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Booking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: const Color(0xFF6D674B), // Line color
            width: 50,
            height: 1.0, // Line thickness
          ),
        ),
      ),
      body: FutureBuilder<List<BookingDTO>>(
        future: _bookingItemsFuture, // Fetch bookings from the service
        builder: (context, snapshot) {
          // Check the connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any errors during data fetching
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData && snapshot.data!.isEmpty) {
            // Display when no booking data is available
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off,
                      size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No Courses',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Looks like you have not enrolled for any course yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to all courses page
                      Navigator.pushNamed(context, '/all_courses');
                    },
                    child: const Text('Explore Courses'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            List<BookingDTO> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingItem(booking);
              },
            );
          } else {
            // Display if no data is available (fallback case)
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildBookingItem(BookingDTO booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking details at the top
            Text(
              'Booking ID: ${booking.id}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Email: ${booking.email}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Booking Date: ${booking.bookingDate.toLocal()}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${booking.status}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Amount: \$${booking.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            // See More button to toggle details
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  backgroundColor: Colors.white.withOpacity(0.8),
                  foregroundColor: const Color(0xFF6D674B),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_isExpanded ? 'Hide Details' : 'See More'),
              ),
            ),
            // Conditional rendering of booking details
            if (_isExpanded) const SizedBox(height: 8),
            if (_isExpanded)
              const Text(
                'Booking Details:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            if (_isExpanded) const SizedBox(height: 8),
            if (_isExpanded)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: booking.bookingDetails.length,
                itemBuilder: (context, detailIndex) {
                  final detail = booking.bookingDetails[detailIndex];
                  print("detail: ${detail.instance.imageUrl}");
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Displaying instance details similarly to `_buildCartItem`
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Instance ID: ${detail.instance.id ?? "N/A"}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Price: \$${detail.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (detail.instance.courseId != null)
                                  Text(
                                    'Course ID: ${detail.instance.courseId}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                if (detail.instance.teacher != null)
                                  Text(
                                    'Teacher: ${detail.instance.teacher}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Displaying image placeholder or image (if applicable)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: detail.instance.imageUrl.isNotEmpty
                                ? SizedBox(
                                    width: 150, // Set a defined width
                                    height: 150, // Set a defined height
                                    child: Image.memory(
                                      _base64Decode(detail.instance.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset(
                                      'assets/images/courses/default_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
