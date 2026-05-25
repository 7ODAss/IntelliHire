import '../../domain/entities/question_result.dart';

class QuestionResultModel extends QuestionResult {
  const QuestionResultModel({
    required super.questionText,
    required super.userAnswer,
    required super.idealAnswer,
  });

  factory QuestionResultModel.fromJson(Map<String, dynamic> json) => QuestionResultModel(
        questionText: json['questionText'] as String? ?? '',
        userAnswer: json['userAnswer'] as String? ?? '',
        idealAnswer: json['idealAnswer'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'questionText': questionText,
        'userAnswer': userAnswer,
        'idealAnswer': idealAnswer,
      };
}
