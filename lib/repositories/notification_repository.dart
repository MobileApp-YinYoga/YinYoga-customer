import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('notifications').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = int.parse(doc.id); // Parse string to int for ID
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

  Future<void> updateNotification(int id, Map<String, dynamic> data) async {
    try {
      String idString = id.toString(); // Convert int id to string for Firestore
      await _firestore.collection('notifications').doc(idString).update(data);
    } catch (e) {
      print('Error updating notification: $e');
    }
  }
}
