import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead ? Colors.grey[300] : Colors.white,
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.description ?? ''),
        trailing: IconButton(
          icon: Icon(Icons.check_circle),
          onPressed: onMarkAsRead,
        ),
      ),
    );
  }
}
