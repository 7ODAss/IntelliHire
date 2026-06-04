import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';

import '../../../../../core/error/failure.dart';
import '../../../assess manage/domain/entities/question_result.dart';
import '../entities/performance_report.dart';
import '../entities/question.dart';

abstract class BaseNewAssessRepository {
  Future<Either<Failure, List<Question>>> fetchAssessmentQuestions(CvData cv);

  Future<Either<Failure, PerformanceReport>> submitInterview(
    Map<String, String> voiceTextAnswers,
    Map<String, String> mcqAnswers,
    List<Question> originalQuestions,
    CvData cv,
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

  Future<Either<Failure, (String, String)>> getCandidateId();
  Future<Either<Failure, CvData>> getCandidateCv(String id);
}
