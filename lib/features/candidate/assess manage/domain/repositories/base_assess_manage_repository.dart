import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/assessment.dart';
import '../entities/performance_report.dart';

abstract class BaseAssessManageRepository {
  Future<Either<Failure, List<Assessment>>> fetchAssessmentHistory();
  Future<Either<Failure, PerformanceReport>> fetchPerformanceReport(String assessmentId);
}
