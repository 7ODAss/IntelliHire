import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String notificationId); 
}