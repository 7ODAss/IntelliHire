import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';

class GetJobDetailsUseCase {
  final JobRepo repository;
  GetJobDetailsUseCase(this.repository);

  Future<Either<String, JobItemEntity>> execute(String jobId) async {
    return await repository.getJobDetails(jobId);
  }
}