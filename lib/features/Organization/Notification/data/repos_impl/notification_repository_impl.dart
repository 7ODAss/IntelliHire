import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Entities/notification_entity.dart';
import '../DataSources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSourceOrganization remoteDataSource;
  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await remoteDataSource.getNotifications();
    return models.map((model) => model as NotificationEntity).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await remoteDataSource.markAsRead(notificationId);
  }
}