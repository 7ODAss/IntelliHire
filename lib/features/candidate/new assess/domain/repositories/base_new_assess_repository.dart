import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../assess manage/domain/entities/question_result.dart';
import '../entities/performance_report.dart';
import '../entities/question.dart';

abstract class BaseNewAssessRepository {
  Future<Either<Failure, List<Question>>> fetchAssessmentQuestions(
    String title,
    String track,
  );

  Future<Either<Failure, PerformanceReport>> submitInterview(
    Map<String, String> voiceTextAnswers,
    Map<String, String> mcqAnswers,
    List<Question> originalQuestions,
    String title,
    String track,
    String avgReply, // 🌟 ضفناه هنا
    String totalTime, // 🌟 ضفناه هنا
  );

  Future<Either<Failure, String>> sendAssessment(
    String trackName,
    String assessmentName,
    double overallAiScore,
    double accuracy,
    String avgReply,
    int totalQuestions,
    String duration,
    List<QuestionResult> questions,
  );
}
