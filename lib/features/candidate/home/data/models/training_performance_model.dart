import 'package:intelli_hire/features/candidate/home/domain/entities/training_performance.dart';

class TrainingPerformanceModel extends TrainingPerformance {
  const TrainingPerformanceModel({
    required super.firstName,
    required super.totalExams,
    required super.averageScore,
    required super.weekLabel,
    required super.weeklyActivity,
    required super.dailyAverageScores,
  });
  factory TrainingPerformanceModel.fromJson(Map<String, dynamic> json) {
    return TrainingPerformanceModel(
      firstName: json['firstName'],
      totalExams: json['totalExams'],
      averageScore: json['averageScore'],
      weekLabel: json['weekLabel'],
      weeklyActivity:
          (json['weeklyActivity'] as List?)
              ?.map((e) => (e as num?)?.toInt() ?? 0)
              .toList() ??
          [],
      dailyAverageScores:
          (json['dailyAverageScores'] as List?)
              ?.map((e) => (e as num?)?.toDouble() ?? 0.0)
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'totalExams': totalExams,
      'averageScore': averageScore,
      'weekLabel': weekLabel,
      'weeklyActivity': weeklyActivity,
      'dailyAverageScores': dailyAverageScores,
    };
  }
}
