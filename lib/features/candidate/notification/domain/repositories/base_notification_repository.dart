import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/notification_item.dart';

abstract class BaseNotificationRepository {
  Future<Either<Failure, List<NotificationItem>>> fetchNotifications();
}
