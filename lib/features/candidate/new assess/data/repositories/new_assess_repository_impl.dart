import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/datasources/new_assess_remote_datasource.dart';

class NewAssessRepositoryImpl implements BaseNewAssessRepository {
  final BaseNewAssessDataSource dataSource;
  NewAssessRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Question>>> fetchAssessmentQuestions(
    String assessmentId,
  ) async {
    try {
      // Cast List<QuestionModel> → List<Question> (model extends entity)
      final models = await dataSource.fetchAssessmentQuestions(assessmentId);
      return Right(models.cast<Question>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceReport>> submitInterview(
    String assessmentId,
    List<String> recordingPaths,
    Map<String, String> mcqAnswers,
  ) async {
    try {
      // PerformanceReportModel extends PerformanceReport — valid upcast
      final model = await dataSource.submitInterview(
        assessmentId,
        recordingPaths,
        mcqAnswers,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
