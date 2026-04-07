import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.isRead = false,
  });

  factory NotificationItem.empty() => const NotificationItem(
        id: '',
        title: '',
        body: '',
        timeAgo: '',
      );

  @override
  List<Object?> get props => [id, title, body, timeAgo, isRead];
}
