import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import '../Repos/candidate_notfication_repo.dart';

class DeleteNotificationUseCase {
  final CandidateNotficationRepo repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteNotification(id);
  }
}