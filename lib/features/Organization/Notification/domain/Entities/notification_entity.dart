class NotificationEntity {
  final String? id;
  final String? title;
  final String? description;
  final String? time;
  final bool isRead;

  NotificationEntity({
    this.id,
    this.title,
    this.description,
    this.time,
    required this.isRead,
  });
}
