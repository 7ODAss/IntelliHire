import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/question.dart';
import '../entities/performance_report.dart';

abstract class BaseNewAssessRepository {
  Future<Either<Failure, List<Question>>> fetchAssessmentQuestions(String assessmentId);
  Future<Either<Failure, PerformanceReport>> submitInterview(
    String assessmentId,
    List<String> recordingPaths,
    Map<String, String> mcqAnswers,
  );
}
