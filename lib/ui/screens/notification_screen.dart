import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _newNotifications = [];
  List<NotificationModel> _oldNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      List<NotificationModel> notifications = await _notificationService.getNotifications();
      DateTime today = DateTime.now();
      setState(() {
        _newNotifications = notifications.where((notification) {
          DateTime notificationDate = DateTime.parse(notification.time);
          return notificationDate.year == today.year &&
              notificationDate.month == today.month &&
              notificationDate.day == today.day;
        }).toList();
        _oldNotifications = notifications.where((notification) {
          DateTime notificationDate = DateTime.parse(notification.time);
          return !(notificationDate.year == today.year &&
              notificationDate.month == today.month &&
              notificationDate.day == today.day);
        }).toList();
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
          : _buildNotificationsContent(),
    );
  }

  Widget _buildNotificationsContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (_newNotifications.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('New', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ..._newNotifications.map((notification) => _buildNotificationCard(notification)).toList(),
        if (_oldNotifications.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Before', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ..._oldNotifications.map((notification) => _buildNotificationCard(notification)).toList(),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id!),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        await _notificationService.deleteNotification(notification.id!);
        setState(() {
          _newNotifications.remove(notification);
          _oldNotifications.remove(notification);
        });
      },
      child: Card(
        color: notification.isRead ? Colors.white : const Color(0x4D6D674B), // 30% opacity of 0xFF6D674B
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
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(notification.time)),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(notification.isRead ? Icons.mark_chat_read : Icons.mark_chat_unread),
            onPressed: () {
              _toggleReadStatus(notification);
            },
          ),
          onTap: () {
            _toggleReadStatus(notification);
          },
        ),
      ),
    );
  }

  Future<void> _toggleReadStatus(NotificationModel notification) async {
    try {
      final updatedNotification = notification.copyWith(isRead: !notification.isRead);
      await _notificationService.markAsRead(notification.id!);
      setState(() {
        if (_newNotifications.contains(notification)) {
          _newNotifications[_newNotifications.indexWhere((n) => n.id == notification.id)] =
              updatedNotification;
        } else {
          _oldNotifications[_oldNotifications.indexWhere((n) => n.id == notification.id)] =
              updatedNotification;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update notification status: $e')),
      );
    }
  }
}
