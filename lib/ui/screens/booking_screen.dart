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
  final BookingService _bookingService = BookingService();
  late Future<List<BookingDTO>> _bookingItemsFuture;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _bookingItemsFuture =
        _bookingService.fetchBookingsByEmail(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<BookingDTO>>(
        future: _bookingItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorView(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyView();
          } else {
            return _buildBookingList(snapshot.data!);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
      elevation: 1, // Remove default shadow to create a clean line appearance
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0), // Height of the line
        child: Container(
          color: const Color(0xFF6D674B), // Line color
          width: 50,
          height: 1.0, // Line thickness
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Error: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
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
              Navigator.pushNamed(context, '/all_courses');
            },
            child: const Text('Explore Courses'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<BookingDTO> bookings) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingItem(booking);
      },
    );
  }

  Widget _buildBookingItem(BookingDTO booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingHeader(booking),
            const SizedBox(height: 12),
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
                  backgroundColor: const Color(0xFF6D674B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(_isExpanded ? 'Hide Details' : 'See More',
                    style:
                        const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                color: const Color(0xFF6D674B),
                height: 1.0,
              ),
              const SizedBox(height: 8),
              const Text(
                'Booking Details:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6D674B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              _buildBookingDetailsList(booking),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHeader(BookingDTO booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking ID: ${booking.id}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D674B),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Email: ${booking.email}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323232),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Booking Date: ${booking.bookingDate.toLocal()}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323232),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Status: ${booking.status}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323232),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total Amount: \$${booking.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323232),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDetailsList(BookingDTO booking) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: booking.bookingDetails.length,
      itemBuilder: (context, detailIndex) {
        final detail = booking.bookingDetails[detailIndex];
        return _buildBookingDetailItem(detail);
      },
    );
  }

  Widget _buildBookingDetailItem(dynamic detail) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                // Handle image tap action here (e.g., navigate to course details)
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: detail.instance.imageUrl.isNotEmpty
                        ? Image.memory(
                            _base64Decode(detail.instance.imageUrl),
                            width: double.infinity,
                            height: 130,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/courses/default_image.png',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Corner radius 20
                      color: const Color(0xFF6D674B)
                          .withOpacity(0.3), // Fill 6D674B with opacity 40%
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: \$${detail.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (detail.instance.courseId != null)
                        Text(
                          'Course ID: ${detail.instance.courseId}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      if (detail.instance.teacher != null)
                        Text(
                          'Teacher: ${detail.instance.teacher}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
