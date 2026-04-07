import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/domain/entities/performance_report.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';

class SubmitInterviewParams extends Equatable {
  final String assessmentId;
  final List<String> recordingPaths;
  final Map<String, String> mcqAnswers;

  const SubmitInterviewParams({
    required this.assessmentId,
    required this.recordingPaths,
    required this.mcqAnswers,
  });

  @override
  List<Object?> get props => [assessmentId, recordingPaths, mcqAnswers];
}

class SubmitInterviewUseCase extends BaseUseCase<PerformanceReport, SubmitInterviewParams> {
  final BaseNewAssessRepository repo;
  SubmitInterviewUseCase(this.repo);

  @override
  Future<Either<Failure, PerformanceReport>> call(SubmitInterviewParams parameters) =>
      repo.submitInterview(
        parameters.assessmentId,
        parameters.recordingPaths,
        parameters.mcqAnswers,
      );
}
