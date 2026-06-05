import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';

class GetNotificationsUseCase {
  final BaseNotificationRepository repository;

  GetNotificationsUseCase(this.repository);
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}