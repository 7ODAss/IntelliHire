import '../../domain/entities/assessment.dart';

class AssessmentModel extends Assessment {
  const AssessmentModel({
    required super.id,
    required super.title,
    required super.track,
    required super.aiScore,
    required super.performanceBadge,
    required super.date,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) => AssessmentModel(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        track: json['track'] as String? ?? '',
        aiScore: (json['ai_score'] as num?)?.toDouble() ?? 0,
        performanceBadge: json['performance_badge'] as String? ?? '',
        date: json['date'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'track': track,
        'ai_score': aiScore,
        'performance_badge': performanceBadge,
        'date': date,
      };
}
