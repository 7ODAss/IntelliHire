import 'package:intelli_hire/features/candidate/home/domain/entities/training_performance.dart';

class TrainingPerformanceModel extends TrainingPerformance {
  const TrainingPerformanceModel({
    required super.userName,
    required super.totalExams,
    required super.averageScore,
  });
  factory TrainingPerformanceModel.fromJson(Map<String, dynamic> json) {
    return TrainingPerformanceModel(
      userName: json['user_name'],
      totalExams: json['total_exams'],
      averageScore: json['average_score'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'user_name': userName,
      'total_exams': totalExams,
      'average_score': averageScore,
    };
  }
}
