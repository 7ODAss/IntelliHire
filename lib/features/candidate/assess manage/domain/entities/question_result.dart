import 'package:equatable/equatable.dart';

class QuestionResult extends Equatable {
  final String questionText;
  final String transcribedAnswer;
  final String idealAnswer;

  const QuestionResult({
    required this.questionText,
    required this.transcribedAnswer,
    required this.idealAnswer,
  });

  factory QuestionResult.empty() => const QuestionResult(
        questionText: '',
        transcribedAnswer: '',
        idealAnswer: '',
      );

  @override
  List<Object?> get props => [questionText, transcribedAnswer, idealAnswer];
}
