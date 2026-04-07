import 'package:intelli_hire/features/candidate/home/data/models/home_summary_model.dart';

import '../models/interview_summary_model.dart';
import '../models/training_performance_model.dart';

abstract class BaseHomeDataSource {
  Future<HomeSummaryModel> getHomeSummary();
}

/// Stub implementation — returns placeholder until AI API is ready.
class HomeRemoteDataSource implements BaseHomeDataSource {
  @override
  Future<HomeSummaryModel> getHomeSummary() async {
    await Future.delayed(const Duration(seconds: 5));
    return HomeSummaryModel(
      trainingPerformance: TrainingPerformanceModel(
        userName: 'John Doe',
        totalExams: 10,
        averageScore: 85.5,
      ),
      interviewSummary: InterviewSummaryModel(
        accepted: 5,
        inProgress: 2,
        pending: 3,
        rejected: 2,
      ),
    );
  }
}
