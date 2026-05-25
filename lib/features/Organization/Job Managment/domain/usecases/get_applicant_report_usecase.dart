import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/applicants_repo.dart';

class GetApplicantReportUseCase {
  final ApplicantsRepo repository;

  GetApplicantReportUseCase(this.repository);

  Future<Either<String, ReportEntity>> execute(String sessionId) async {
    return await repository.getApplicantPreview(sessionId);
  }
}
