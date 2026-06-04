import '../../domain/entities/performance_report.dart';
import 'question_result_model.dart';

class PerformanceReportModel extends PerformanceReport {
  const PerformanceReportModel({
    required super.title,

    required super.overallAiScore,
    required super.questionsCount,
    required super.accuracy,
    required super.totalTime,
    required super.avgReply,
    required super.questions,
  });

  factory PerformanceReportModel.fromJson(Map<String, dynamic> json) =>
      PerformanceReportModel(
        title: json['title'] as String? ?? '',

        overallAiScore: (json['overallAiScore'] as num?)?.toDouble() ?? 0,
        questionsCount: (json['questionsCount'] as int?) ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
        totalTime: json['totalTime'] ?? 0,
        avgReply: json['avgReply'] ?? 0,
        questions:
            (json['questions'] as List<dynamic>?)
                ?.map(
                  (e) =>
                      QuestionResultModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'overallAiScore': overallAiScore,
    'questionsCount': questionsCount,
    'accuracy': accuracy,
    'totalTime': totalTime,
    'avgReply': avgReply,
    'questions': questions
        .map(
          (r) => QuestionResultModel(
            questionText: r.questionText,
            userAnswer: r.userAnswer,
            idealAnswer: r.idealAnswer,
          ).toJson(),
        )
        .toList(),
  };
}
