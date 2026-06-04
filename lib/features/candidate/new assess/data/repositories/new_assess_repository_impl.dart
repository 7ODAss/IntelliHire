import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/question_result.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/datasources/new_assess_remote_datasource.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';

class NewAssessRepositoryImpl implements BaseNewAssessRepository {
  final BaseNewAssessDataSource dataSource;

  NewAssessRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Question>>> fetchAssessmentQuestions(
    CvData cv,
  ) async {
    try {
      // Cast List<QuestionModel> → List<Question> (model extends entity)
      final models = await dataSource.fetchAssessmentQuestions(cv);
      return Right(models.cast<Question>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PerformanceReport>> submitInterview(
    Map<String, String> recordingPaths,
    Map<String, String> mcqAnswers,
    List<Question> originalQuestions,
    CvData cv,
    String avgReply,
    String totalTime,
  ) async {
    try {
      // PerformanceReportModel extends PerformanceReport — valid upcast
      final model = await dataSource.submitInterview(
        recordingPaths,
        mcqAnswers,
        originalQuestions,
        cv,
        avgReply,
        totalTime,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendAssessment(
    String trackName,
    String assessmentName,
    double overallAiScore,
    double accuracy,
    String avgReply,
    int totalQuestions,
    String duration,
    List<QuestionResult> questions,
  ) async {
    try {
      final result = await dataSource.sendAssessment(
        trackName,
        assessmentName,
        overallAiScore,
        accuracy,
        avgReply,
        totalQuestions,
        duration,
        questions,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, (String, String)>> getCandidateId() async {
    try {
      final result = await dataSource.getCandidateId();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CvData>> getCandidateCv(String id) async {
    try {
      final result = await dataSource.getCandidateCv(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
