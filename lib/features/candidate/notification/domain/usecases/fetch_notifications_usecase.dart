import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/notification_item.dart';
import '../repositories/base_notification_repository.dart';

class FetchNotificationsUseCase extends BaseUseCase<List<NotificationItem>, NoParameters> {
  final BaseNotificationRepository repo;
  FetchNotificationsUseCase(this.repo);

  @override
  Future<Either<Failure, List<NotificationItem>>> call(NoParameters parameters) =>
      repo.fetchNotifications();
}
