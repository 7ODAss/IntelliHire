import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';

class GetJobsUseCase {
  final JobRepo repository;

  GetJobsUseCase(this.repository);

  Future<Either<String, JobManagementEntity>> execute() async {
    return await repository.getJobsDashboard();
  }
}