import 'package:intelli_hire/core/utils/shared/date_formatter.dart';

class CandidateNotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  bool isRead;

  CandidateNotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });

factory CandidateNotificationModel.fromJson(Map<String, dynamic> json) {
    // 🌟 السطر ده هيفضح الباك إند بالكامل!
    print("========================================");
    print("🔥 RAW JSON FROM BACKEND: $json");
    print("⏰ Value of createdAt: ${json['createdAt']}");
    print("⏰ Value of Time: ${json['time']}");
    print("========================================");

    String rawTime = json['time']?.toString() ?? 
                     json['createdAt']?.toString() ?? 
                     json['CreatedAt']?.toString() ?? '';

    if (rawTime.isEmpty) {
      rawTime = DateTime.now().toIso8601String(); 
    }

    String formattedTime = rawTime.toTimeAgo();

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

    return CandidateNotificationModel(
      id: parsedId ?? "temp_${DateTime.now().millisecondsSinceEpoch}",
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['body'] ?? json['Body'] ?? '',
      time: formattedTime,
      isRead: json['isRead'] ?? json['IsRead'] ?? false,
    );
  }
}
