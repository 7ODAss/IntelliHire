import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_applicants_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';

abstract class ApplicantsRepo {
  Future<Either<String, JobApplicantsListEntity>> getJobApplicants(String jobId);
  Future<Either<String, ReportEntity>> getApplicantPreview(String sessionId); 
}