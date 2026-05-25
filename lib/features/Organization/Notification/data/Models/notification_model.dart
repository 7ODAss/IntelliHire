import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.time,
    required super.isUnread,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      isUnread: json['isUnread'] ?? false,
    );
  }
}