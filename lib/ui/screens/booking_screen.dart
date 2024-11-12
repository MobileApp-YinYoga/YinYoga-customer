import 'package:flutter/material.dart';
import 'package:yinyoga_customer/services/booking_service.dart';

class BookingScreen extends StatelessWidget {
  final String userEmail; // Current user's email to fetch booking data
  final BookingService _bookingService =
      BookingService(); // Initialize BookingService

  BookingScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Booking',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingService
            .getUserBookings(userEmail), // Fetch bookings from the service
        builder: (context, snapshot) {
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
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
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
            // Display the list of bookings
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(
                        booking['instanceId'].substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                            color: Color(0xFF6D674B),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Instance ID: ${booking['instanceId']}',
                      style: const TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${booking['status']}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Date: ${booking['bookingDate']}',
                          style: const TextStyle(
                              color: Colors.grey, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey),
                      onPressed: () {
                        // Handle navigation or action on booking
                      },
                    ),
                  ),
                );
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
}
