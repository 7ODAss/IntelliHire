import 'package:equatable/equatable.dart';

class QuestionResult extends Equatable {
  final String questionText;
  final String idealAnswer;
  final String userAnswer;

  const QuestionResult({
    required this.questionText,
    required this.idealAnswer,
    required this.userAnswer,
  });

  factory QuestionResult.empty() =>
      const QuestionResult(questionText: '', idealAnswer: '', userAnswer: '');

  @override
  List<Object?> get props => [questionText, idealAnswer, userAnswer];
}
