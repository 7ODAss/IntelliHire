import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';

abstract class JobRepo {
  Future<Either<String, JobManagementEntity>> getJobsDashboard();
  Future<Either<String, void>> deleteJob(String jobId);
  Future<Either<String, void>> updateJob(String jobId, Map<String, dynamic> jobData);
  Future<Either<String, JobItemEntity>> getJobDetails(String jobId);
}