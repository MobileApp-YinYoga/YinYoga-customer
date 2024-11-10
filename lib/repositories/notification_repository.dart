import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('notifications').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Use doc.id directly as a string
        return NotificationModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toMap());
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  Future<void> updateNotification(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('notifications').doc(id).update(data);
    } catch (e) {
      print('Error updating notification: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
}
