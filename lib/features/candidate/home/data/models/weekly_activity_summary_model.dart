import 'package:intelli_hire/features/candidate/home/domain/entities/weekly_activity_summary.dart';

class WeeklyActivitySummaryModel extends WeeklyActivitySummary{
  const WeeklyActivitySummaryModel({required super.weekLabel, required super.weeklyActivity});

  factory WeeklyActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    final List<int> weeklyActivity = List<int>.from(json['weeklyActivity']);
    return WeeklyActivitySummaryModel(
      weekLabel: json['weekLabel'],
      weeklyActivity: weeklyActivity,
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'weekLabel': weekLabel,
      'weeklyActivity': weeklyActivity,
    };
  }
}