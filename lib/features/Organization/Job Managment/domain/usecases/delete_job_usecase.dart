import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';

class DeleteJobUseCase {
  final JobRepo repository;

  DeleteJobUseCase(this.repository);

  Future<Either<String, void>> execute(String jobId) async {
    return await repository.deleteJob(jobId);
  }
}