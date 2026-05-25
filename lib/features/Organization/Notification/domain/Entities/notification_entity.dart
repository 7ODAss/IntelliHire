class NotificationEntity {
  final String id;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.isUnread,
  });
}