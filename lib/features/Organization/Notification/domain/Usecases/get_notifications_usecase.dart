import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
}