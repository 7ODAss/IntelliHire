import 'package:equatable/equatable.dart';
import 'question_result.dart';

class PerformanceReport extends Equatable {
  final String title;
  final String track;
  final String assessmentId;
  final double aiScore;
  final int totalQuestions;
  final double accuracy;
  final String totalTime;
  final String avgReply;
  final List<QuestionResult> results;

  const PerformanceReport({
    required this.title,
    required this.track,
    required this.assessmentId,
    required this.aiScore,
    required this.totalQuestions,
    required this.accuracy,
    required this.totalTime,
    required this.avgReply,
    required this.results,
  });

  factory PerformanceReport.empty() => const PerformanceReport(
        title: '',
        track: '',
        assessmentId: '',
        aiScore: 0,
        totalQuestions: 0,
        accuracy: 0,
        totalTime: '',
        avgReply: '',
        results: [],
      );

  @override
  List<Object?> get props =>
      [title,track,assessmentId, aiScore, totalQuestions, accuracy, totalTime, avgReply, results];
}
