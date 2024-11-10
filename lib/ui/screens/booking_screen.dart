import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yinyoga_customer/services/booking_service.dart';

class BookingScreen extends StatelessWidget {
  final String userEmail; // Email của người dùng hiện tại để lấy dữ liệu booking
  final BookingService _bookingService = BookingService(); // Khởi tạo BookingService để làm việc với dữ liệu
  BookingScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Booking'), // Tiêu đề AppBar
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingService.getUserBookings(userEmail), // Lấy dữ liệu booking từ dịch vụ
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị vòng tròn tải khi dữ liệu đang được lấy
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiển thị lỗi nếu xảy ra lỗi trong quá trình lấy dữ liệu
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Hiển thị giao diện khi không có dữ liệu booking
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Looks like you have not enrolled for any course yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Chuyển hướng đến trang tất cả các khoá học khi người dùng nhấn nút
                      Navigator.pushNamed(context, '/all_courses');
                    },
                    child: const Text('Explore Courses'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // Hiển thị danh sách booking nếu có dữ liệu
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length, // Số lượng item trong danh sách
              itemBuilder: (context, index) {
                final booking = bookings[index]; // Dữ liệu booking tại vị trí index
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Cách đều các card
                  child: ListTile(
                    title: Text('Instance ID: ${booking['instanceId']}'), // Hiển thị ID của instance
                    subtitle: Text('Status: ${booking['status']}'), // Hiển thị trạng thái booking
                    trailing: Text(
                      booking['bookingDate'], // Hiển thị ngày đặt
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          } else {
            // Trường hợp không có dữ liệu khả dụng
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
