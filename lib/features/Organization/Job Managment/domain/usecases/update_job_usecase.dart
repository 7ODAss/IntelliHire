import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';

class UpdateJobUseCase {
  final JobRepo repository;
  UpdateJobUseCase(this.repository);

  Future<Either<String, void>> execute(String jobId, Map<String, dynamic> jobData) async {
    return await repository.updateJob(jobId, jobData);
  }
}