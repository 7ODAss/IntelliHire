import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Entities/candidate_notification_entity.dart';

abstract class CandidateNotficationRepo {
  Future<Either<Failure, List<CandidateNotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAllAsRead(); 
  Future<Either<Failure, void>> deleteNotification(String id);
}