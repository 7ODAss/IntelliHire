class CandidateNotificationEntity {
  final String? id;
  final String? title;
  final String? description;
  final String? time;
  final bool isRead;

  CandidateNotificationEntity({
    this.id,
    this.title,
    this.description,
    this.time,
    required this.isRead,
  });
}
