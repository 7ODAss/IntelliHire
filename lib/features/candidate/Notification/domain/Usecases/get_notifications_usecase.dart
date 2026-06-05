import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Entities/candidate_notification_entity.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Repos/candidate_notfication_repo.dart';


class GetNotificationsUseCase {
  final CandidateNotficationRepo repository;

  GetNotificationsUseCase(this.repository);
  Future<Either<Failure, List<CandidateNotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}