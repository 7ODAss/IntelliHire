import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import '../Repos/notfication_repo.dart';

class DeleteNotificationUseCase {
  final BaseNotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteNotification(id);
  }
}