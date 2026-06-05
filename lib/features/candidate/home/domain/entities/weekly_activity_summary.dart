import 'package:equatable/equatable.dart';

class WeeklyActivitySummary extends Equatable {
  final String weekLabel;
  final List<int> weeklyActivity;

  const WeeklyActivitySummary({
    required this.weekLabel,
    required this.weeklyActivity,
  });

  @override
  List<Object?> get props => [weekLabel, weeklyActivity];
}