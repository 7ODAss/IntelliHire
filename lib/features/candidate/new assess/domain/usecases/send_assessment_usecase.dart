import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';

import '../../../assess manage/domain/entities/question_result.dart';
import '../repositories/base_new_assess_repository.dart';

class SendAssessmentUseCase extends BaseUseCase<String, SendAssessmentParams> {
  final BaseNewAssessRepository repo;

  SendAssessmentUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(SendAssessmentParams parameters) {
    return repo.sendAssessment(
      parameters.trackName,
      parameters.assessmentName,
      parameters.overallAiScore,
      parameters.accuracy,
      parameters.avgReply,
      parameters.totalQuestions,
      parameters.duration,
      parameters.questions,
    );
  }
}

class SendAssessmentParams extends Equatable {
  final String trackName;
  final String assessmentName;
  final double overallAiScore;
  final double accuracy;
  final String avgReply;
  final int totalQuestions;
  final String duration;
  final List<QuestionResult> questions;

  const SendAssessmentParams({
    required this.trackName,
    required this.assessmentName,
    required this.overallAiScore,
    required this.accuracy,
    required this.avgReply,
    required this.totalQuestions,
    required this.duration,
    required this.questions,
  });

  @override
  List<Object?> get props => [
    trackName,
    assessmentName,
    overallAiScore,
    accuracy,
    avgReply,
    totalQuestions,
    duration,
    questions,
  ];
}
