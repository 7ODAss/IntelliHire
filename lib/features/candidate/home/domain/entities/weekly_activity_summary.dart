import 'package:equatable/equatable.dart';

class WeeklyActivitySummary extends Equatable {
  final String weekLabel;
  final List<int> weeklyActivity;
  final List<double> dailyAverageScores;

  const WeeklyActivitySummary({
    required this.weekLabel,
    required this.weeklyActivity,
    required this.dailyAverageScores,
  });

  @override
  List<Object?> get props => [weekLabel, weeklyActivity, dailyAverageScores];
}