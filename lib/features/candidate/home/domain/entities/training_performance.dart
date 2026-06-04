import 'package:equatable/equatable.dart';

class TrainingPerformance extends Equatable {
  final String firstName;
  final int totalExams;
  final num averageScore;
  final String weekLabel;
  final List<int> weeklyActivity;
  final List<double> dailyAverageScores;

  const TrainingPerformance({
    required this.firstName,
    required this.totalExams,
    required this.averageScore,
    required this.weekLabel,
    required this.weeklyActivity,
    required this.dailyAverageScores,
  });

  TrainingPerformance copyWith({
    String? firstName,
    int? totalExams,
    num? averageScore,
    String? weekLabel,
    List<int>? weeklyActivity,
    List<double>? dailyAverageScores,
  }) {
    return TrainingPerformance(
      firstName: firstName ?? this.firstName,
      totalExams: totalExams ?? this.totalExams,
      averageScore: averageScore ?? this.averageScore,
      weekLabel: weekLabel ?? this.weekLabel,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      dailyAverageScores: dailyAverageScores ?? this.dailyAverageScores,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    totalExams,
    averageScore,
    weekLabel,
    weeklyActivity,
    dailyAverageScores,
  ];
}
