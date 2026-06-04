import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/work_experience.dart';

class WorkExperienceModel extends WorkExperience {
  const WorkExperienceModel({
    required super.title,
    required super.company,
    required super.dateRange,
    required super.description,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      dateRange: json['dateRange'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'dateRange': dateRange,
    'description': description,
  };
}
