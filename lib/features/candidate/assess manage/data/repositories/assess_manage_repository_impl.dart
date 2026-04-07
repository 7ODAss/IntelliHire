import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/entities/performance_report.dart';
import '../../domain/repositories/base_assess_manage_repository.dart';
import '../datasources/assess_manage_remote_datasource.dart';

class AssessManageRepositoryImpl implements BaseAssessManageRepository {
  final BaseAssessManageDataSource dataSource;
  AssessManageRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Assessment>>> fetchAssessmentHistory() async {
    try {
      // Cast List<AssessmentModel> → List<Assessment> (model extends entity)
      final models = await dataSource.fetchAssessmentHistory();
      return Right(models.cast<Assessment>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceReport>> fetchPerformanceReport(
    String assessmentId,
  ) async {
    try {
      // PerformanceReportModel extends PerformanceReport — valid upcast
      final model = await dataSource.fetchPerformanceReport(assessmentId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
