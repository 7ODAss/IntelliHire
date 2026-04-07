import 'package:equatable/equatable.dart';

class TrainingPerformance extends Equatable {
  final String userName;
  final int totalExams;
  final double averageScore;
  const TrainingPerformance({
    required this.userName,
    required this.totalExams,
    required this.averageScore,
  });

  @override
  List<Object?> get props => [userName, totalExams, averageScore];
}
