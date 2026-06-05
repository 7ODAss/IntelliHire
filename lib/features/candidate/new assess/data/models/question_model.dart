import '../../domain/entities/question.dart';
import '../../domain/entities/question_type.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.number,
    required super.total,
    required super.type,
    super.options,
    super.correctOption,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: json['id'] as String? ?? '',
    text: json['text'] as String? ?? '',
    number: (json['number'] as int?) ?? 1,
    total: (json['total'] as int?) ?? 1,
    type: (json['type'] as String?) == 'mcq'
        ? QuestionType.mcq
        : QuestionType.audio,
    options: List<String>.from(json['options'] ?? []),
    correctOption: json['correct_option'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'number': number,
    'total': total,
    'type': type == QuestionType.mcq ? 'mcq' : 'audio',
    'options': options,
    'correct_option': correctOption,
  };
}
