import 'package:equatable/equatable.dart';

class TrainingPerformance extends Equatable {
  final String firstName;
  final int totalExams;
  final num averageScore;
  final String weekLabel;
  final List<int>weeklyActivity;
  const TrainingPerformance({
    required this.firstName,
    required this.totalExams,
    required this.averageScore,
    required this.weekLabel,
    required this.weeklyActivity,
  });

  @override
  List<Object?> get props => [firstName, totalExams, averageScore,weekLabel, weeklyActivity];
}
