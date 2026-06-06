import 'package:intelli_hire/features/candidate/home/domain/entities/weekly_activity_summary.dart';

class WeeklyActivitySummaryModel extends WeeklyActivitySummary {
  const WeeklyActivitySummaryModel({
    required super.weekLabel,
    required super.weeklyActivity,
    required super.dailyAverageScores,
  });

  factory WeeklyActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    final List<int> weeklyActivity = List<int>.from(
      (json['weeklyActivity'] as List? ?? []).map((e) => (e as num?)?.toInt() ?? 0),
    );
    final List<double> dailyAverageScores = List<double>.from(
      (json['dailyAverageScores'] as List? ?? []).map((e) => (e as num?)?.toDouble() ?? 0.0),
    );
    return WeeklyActivitySummaryModel(
      weekLabel: json['weekLabel'] ?? '',
      weeklyActivity: weeklyActivity,
      dailyAverageScores: dailyAverageScores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekLabel': weekLabel,
      'weeklyActivity': weeklyActivity,
      'dailyAverageScores': dailyAverageScores,
    };
  }
}