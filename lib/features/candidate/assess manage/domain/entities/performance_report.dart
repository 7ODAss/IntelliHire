import 'package:equatable/equatable.dart';
import 'question_result.dart';

class PerformanceReport extends Equatable {
  final String title;
  final String track;
  final double overallAiScore;
  final int questionsCount;
  final double accuracy;
  final String totalTime;
  final String avgReply;
  final List<QuestionResult> questions;

  const PerformanceReport({
    required this.title,
    required this.track,
    required this.overallAiScore,
    required this.questionsCount,
    required this.accuracy,
    required this.totalTime,
    required this.avgReply,
    required this.questions,
  });

  factory PerformanceReport.empty() => const PerformanceReport(
        title: '',
        track: '',
        overallAiScore: 0,
        questionsCount: 0,
        accuracy: 0,
        totalTime: '',
        avgReply: '0',
        questions: [],
      );

  @override
  List<Object?> get props =>
      [title,track, overallAiScore, questionsCount, accuracy, totalTime, avgReply, questions];
}
