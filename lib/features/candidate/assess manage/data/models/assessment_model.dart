import '../../domain/entities/assessment.dart';

class AssessmentModel extends Assessment {
  const AssessmentModel({
    required super.sessionId,
    required super.title,
    required super.track,
    required super.aiScore,
    required super.label,
    required super.date,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) => AssessmentModel(
        sessionId: json['sessionId'],
        title: json['title'] ,
        track: json['track'],
        aiScore: json['aiScore'] ,
        label: json['label'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'title': title,
        'track': track,
        'aiScore': aiScore,
        'label': label,
        'date': date,
      };
}
