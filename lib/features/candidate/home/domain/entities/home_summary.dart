import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/training_performance.dart';

import 'interview_summary.dart';

class HomeSummary extends Equatable {
  final TrainingPerformance trainingPerformance;
  final InterviewSummary interviewSummary;

  const HomeSummary({
    required this.trainingPerformance,
    required this.interviewSummary,
  });

  HomeSummary copyWith({
    TrainingPerformance? trainingPerformance,
    InterviewSummary? interviewSummary,
  }) {
    return HomeSummary(
      trainingPerformance: trainingPerformance ?? this.trainingPerformance,
      interviewSummary: interviewSummary ?? this.interviewSummary,
    );
  }

  @override
  List<Object?> get props => [trainingPerformance, interviewSummary];
}
