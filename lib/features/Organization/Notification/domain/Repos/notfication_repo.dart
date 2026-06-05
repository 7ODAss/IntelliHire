import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';

abstract class BaseNotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAllAsRead(); 
  Future<Either<Failure, void>> deleteNotification(String id);
}