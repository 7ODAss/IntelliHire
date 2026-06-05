import 'package:intelli_hire/core/utils/shared/date_formatter.dart';
import '../../domain/Entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.time,
    super.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String rawTime =
        json['time']?.toString() ?? json['createdAt']?.toString() ?? '';

    if (rawTime.isEmpty) {
      rawTime = DateTime.now().toIso8601String();
    }

    String formattedTime = 'Now';
    if (rawTime.contains('T')) {
      formattedTime = rawTime.toTimeAgo();
    } else {
      formattedTime = rawTime;
    }

    final String? parsedId = json['id']?.toString() ??
                             json['Id']?.toString() ??
                             json['notificationId']?.toString() ??
                             json['NotificationId']?.toString() ??
                             json['notificationID']?.toString() ??
                             json['NotificationID']?.toString() ??
                             json['entityId']?.toString() ??
                             json['EntityId']?.toString() ??
                             json['messageId']?.toString() ??
                             json['MessageId']?.toString();

    if (parsedId == null) {
      print("⚠️ WARNING: Notification ID is missing in JSON payload! Raw JSON: $json");
    }

    return NotificationModel(
      id: parsedId ?? "temp_${DateTime.now().millisecondsSinceEpoch}",
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['body'] ?? '',
      time: formattedTime,
      isRead: json['isRead'] ?? json['IsRead'] ?? false,
    );
  }
}
