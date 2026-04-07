import '../../domain/entities/performance_report.dart';
import 'question_result_model.dart';

class PerformanceReportModel extends PerformanceReport {
  const PerformanceReportModel({
    required super.title,
    required super.track,
    required super.assessmentId,
    required super.aiScore,
    required super.totalQuestions,
    required super.accuracy,
    required super.totalTime,
    required super.avgReply,
    required super.results,
  });

  factory PerformanceReportModel.fromJson(Map<String, dynamic> json) => PerformanceReportModel(
        title: json['title'] as String? ?? '',
        track: json['track'] as String? ?? '',
        assessmentId: json['assessment_id'] as String? ?? '',
        aiScore: (json['ai_score'] as num?)?.toDouble() ?? 0,
        totalQuestions: (json['total_questions'] as int?) ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
        totalTime: json['total_time'] as String? ?? '',
        avgReply: json['avg_reply'] as String? ?? '',
        results: (json['results'] as List<dynamic>?)
                ?.map((e) => QuestionResultModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'track': track,
        'assessment_id': assessmentId,
        'ai_score': aiScore,
        'total_questions': totalQuestions,
        'accuracy': accuracy,
        'total_time': totalTime,
        'avg_reply': avgReply,
        'results': results
            .map((r) => QuestionResultModel(
                  questionText: r.questionText,
                  transcribedAnswer: r.transcribedAnswer,
                  idealAnswer: r.idealAnswer,
                ).toJson())
            .toList(),
      };
}
