import 'package:equatable/equatable.dart';
import 'question_type.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final int number;
  final int total;
  final QuestionType type;
  final List<String> options; // empty for audio questions
  final String correctOption; // empty for audio questions

  const Question({
    required this.id,
    required this.text,
    required this.number,
    required this.total,
    required this.type,
    this.options = const [],
    this.correctOption = '',
  });

  factory Question.empty() => const Question(
        id: '',
        text: '',
        number: 1,
        total: 1,
        type: QuestionType.audio,
      );

  @override
  List<Object?> get props => [id, text, number, total, type, options, correctOption];
}
