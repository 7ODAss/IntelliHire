import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';

import '../entities/question.dart';

class SubmitInterviewParams extends Equatable {
  final Map<String, String> voiceTextAnswers;
  final Map<String, String> mcqAnswers;
  final List<Question> originalQuestions;
  final CvData cv;
  final String avgReply; // 🌟 ضفناه هنا
  final String totalTime; // 🌟 ضفناه هنا

  const SubmitInterviewParams({
    required this.voiceTextAnswers,
    required this.mcqAnswers,
    required this.originalQuestions,
    required this.cv,
    required this.avgReply,
    required this.totalTime,
  });

  @override
  List<Object?> get props => [
    voiceTextAnswers,
    mcqAnswers,
    originalQuestions,
    cv,
    avgReply,
    totalTime,
  ];
}

class SubmitInterviewUseCase
    extends BaseUseCase<PerformanceReport, SubmitInterviewParams> {
  final BaseNewAssessRepository repo;

  SubmitInterviewUseCase(this.repo);

  @override
  Future<Either<Failure, PerformanceReport>> call(
    SubmitInterviewParams parameters,
  ) => repo.submitInterview(
    parameters.voiceTextAnswers,
    parameters.mcqAnswers,
    parameters.originalQuestions,
    parameters.cv,
    parameters.avgReply,
    parameters.totalTime,
  );
}
