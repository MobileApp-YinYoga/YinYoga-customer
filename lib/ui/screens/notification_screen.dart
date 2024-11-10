import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/notification_model.dart';
import 'package:yinyoga_customer/repositories/notification_repository.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      List<NotificationModel> notifications = await _notificationRepository.fetchNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch notifications: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildNoNotificationsView()
              : _buildNotificationsList(),
    );
  }

  Widget _buildNoNotificationsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No announcement yet',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            'Notifications you receive will appear here',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        NotificationModel notification = _notifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              Icons.notifications,
              color: notification.isRead ? Colors.grey : Colors.blue,
            ),
            title: Text(notification.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.description != null)
                  Text(notification.description!),
                Text(
                  notification.time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(notification.isRead ? Icons.mark_chat_read : Icons.mark_chat_unread),
              onPressed: () {
                // Toggle read status logic
                _toggleReadStatus(notification);
              },
            ),
            onTap: () {
              // Additional handling on notification tap
              _toggleReadStatus(notification);
            },
          ),
        );
      },
    );
  }

  Future<void> _toggleReadStatus(NotificationModel notification) async {
    try {
      final updatedNotification = notification.copyWith(isRead: !notification.isRead);
      await _notificationRepository.updateNotification(
        notification.id!,
        updatedNotification.toMap(),
      );
      setState(() {
        _notifications[_notifications.indexWhere((n) => n.id == notification.id)] =
            updatedNotification;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update notification status: $e')),
      );
    }
  }
}
