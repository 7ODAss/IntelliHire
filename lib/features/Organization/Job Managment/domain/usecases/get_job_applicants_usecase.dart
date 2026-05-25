import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_applicants_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/applicants_repo.dart';

class GetJobApplicantsUseCase {
  final ApplicantsRepo repository;

  GetJobApplicantsUseCase(this.repository);

  Future<Either<String, JobApplicantsListEntity>> execute(String jobId) async {
    return await repository.getJobApplicants(jobId);
  }
}