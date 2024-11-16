import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/cart_model.dart';
import 'package:yinyoga_customer/models/notification_model.dart';
import 'package:yinyoga_customer/services/notification_service.dart';
import 'package:yinyoga_customer/ui/screens/booking_screen.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> newNotifications = [];
  List<NotificationModel> oldNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      // Fetch all notifications from the service
      List<NotificationModel> notifications =
          await _notificationService.getNotifications();

      DateTime today = DateTime.now();

      setState(() {
        newNotifications = notifications.where((notif) {
          // Check if the notification is from today
          DateTime time = DateTime.parse(notif.time);
          return time.year == today.year &&
              time.month == today.month &&
              time.day == today.day;
        }).toList();

        oldNotifications = notifications.where((notif) {
          // Check if the notification is not from today
          DateTime time = DateTime.parse(notif.time);
          return !(time.year == today.year &&
              time.month == today.month &&
              time.day == today.day);
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 232, 232, 232),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              // New notifications section
              if (newNotifications.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFF6D674B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...newNotifications
                        .map((notif) => _buildNotificationCard(notif, context)),
                  ],
                ),
              // Empty state when no new notifications
              if (newNotifications.isEmpty && !_isLoading)
                // Old notifications section
                if (oldNotifications.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Before',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color(0xFF6D674B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...oldNotifications.map(
                          (notif) => _buildNotificationCard(notif, context)),
                    ],
                  ),
              // Empty state when no old notifications
              if (oldNotifications.isEmpty && !_isLoading)
                const Center(child: Text('No old notifications')),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a notification card widget
  Widget _buildNotificationCard(NotificationModel notif, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.transparent, // Add border when unread
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: Image.asset(
            notif.isRead
                ? 'assets/icons/utils/notification_read.png'
                : 'assets/icons/utils/notification_unread.png',
            width: 30,
            height: 30,
          ),
          title: Text(
            notif.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Color(0xFF6D674B),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notif.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Color(0xFF6D674B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: ${notif.time}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Color(0xFF7B7B7B),
                ),
              ),
            ],
          ),
          onTap: () {
            // Update isRead status and navigate to the booking page
            if (!notif.isRead) {
              _notificationService.markAsRead(notif.id!);
            } else {
              _notificationService.markAsUnread(notif.id!);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingScreen(
                  userEmail: 'trannq2003@gmail.com',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
