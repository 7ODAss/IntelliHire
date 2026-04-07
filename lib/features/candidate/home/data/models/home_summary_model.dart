import 'package:intelli_hire/features/candidate/home/data/models/training_performance_model.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';

import 'interview_summary_model.dart';

class HomeSummaryModel extends HomeSummary {
  const HomeSummaryModel({
    required super.trainingPerformance,
    required super.interviewSummary,
  });
  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return HomeSummaryModel(
      trainingPerformance: TrainingPerformanceModel.fromJson(json['training_performance']),
      interviewSummary: InterviewSummaryModel.fromJson(json['interview_summary']),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'training_performance': trainingPerformance,
      'interview_summary': interviewSummary,
    };
  }
}
