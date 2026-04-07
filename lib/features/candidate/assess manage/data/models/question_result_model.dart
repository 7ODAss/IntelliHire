import '../../domain/entities/question_result.dart';

class QuestionResultModel extends QuestionResult {
  const QuestionResultModel({
    required super.questionText,
    required super.transcribedAnswer,
    required super.idealAnswer,
  });

  factory QuestionResultModel.fromJson(Map<String, dynamic> json) => QuestionResultModel(
        questionText: json['question_text'] as String? ?? '',
        transcribedAnswer: json['transcribed_answer'] as String? ?? '',
        idealAnswer: json['ideal_answer'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'question_text': questionText,
        'transcribed_answer': transcribedAnswer,
        'ideal_answer': idealAnswer,
      };
}
