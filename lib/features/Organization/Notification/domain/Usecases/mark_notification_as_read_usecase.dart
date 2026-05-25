import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}