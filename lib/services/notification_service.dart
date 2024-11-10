import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _repository = NotificationRepository();

  Future<List<NotificationModel>> getNotifications() async {
    return await _repository.fetchNotifications();
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _repository.addNotification(notification);
  }

  Future<void> markAsRead(int id) async {
    await _repository.updateNotification(id, {'isRead': true});
  }

  Future<void> clearNotifications() async {
    List<NotificationModel> notifications = await getNotifications();
    for (var notification in notifications) {
      await _repository.updateNotification(notification.id!, {'isRead': true});
    }
  }
}
