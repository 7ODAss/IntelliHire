import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import '../Repos/candidate_notfication_repo.dart';

class MarkAllNotificationsAsReadUseCase {
  final CandidateNotficationRepo repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markAllAsRead();
  }
}