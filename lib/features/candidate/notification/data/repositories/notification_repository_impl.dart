import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/base_notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImplCandidate implements BaseNotificationRepository {
  final BaseNotificationDataSource dataSource;
  NotificationRepositoryImplCandidate(this.dataSource);

  @override
  Future<Either<Failure, List<NotificationItem>>> fetchNotifications() async {
    try {
      // Cast List<NotificationItemModel> → List<NotificationItem>
      final models = await dataSource.fetchNotifications();
      return Right(models.cast<NotificationItem>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
