import 'package:intelli_hire/features/candidate/home/domain/entities/training_performance.dart';

class TrainingPerformanceModel extends TrainingPerformance {
  const TrainingPerformanceModel({
    required super.firstName,
    required super.totalExams,
    required super.averageScore,
    required super.weekLabel,
    required super.weeklyActivity,
  });
  factory TrainingPerformanceModel.fromJson(Map<String, dynamic> json) {
    return TrainingPerformanceModel(
      firstName: json['firstName'],
      totalExams: json['totalExams'],
      averageScore: json['averageScore'],
      weekLabel: json['weekLabel'],
      weeklyActivity: List<int>.from(json['weeklyActivity']),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'firstName': firstName,
      'totalExams': totalExams,
      'averageScore': averageScore,
      'weekLabel': weekLabel,
      'weeklyActivity': weeklyActivity,
    };
  }
}
