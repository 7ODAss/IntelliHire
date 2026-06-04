import 'package:intelli_hire/features/candidate/new%20assess/data/models/project_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/models/work_experience_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';

class CvDataModel extends CvData {
  const CvDataModel({
    required super.id,
    required super.fullName,
    required super.jobTitle,
    required super.email,
    required super.phoneNumber,
    required super.workExperiences,
    required super.skills,
    required super.projects,
  });

  factory CvDataModel.fromJson(Map<String, dynamic> json) {
    return CvDataModel(
      id: json['id'],
      fullName: json['fullName'],
      jobTitle: json['jobTitle'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      workExperiences: (json['workExperiences'] as List)
          .map(
            (e) => WorkExperienceModel(
              title: e['title'],
              company: e['company'],
              dateRange: e['dateRange'],
              description: e['description'],
            ),
          )
          .toList(),
      skills: (json['skills'] as List).map((e) => e['name'] as String).toList(),
      projects: (json['projects'] as List)
          .map(
            (e) => ProjectModel(
              title: e['title'],
              description: e['description'],
              technologies: List<String>.from(e['technologies']),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'jobTitle': jobTitle,
      'email': email,
      'phoneNumber': phoneNumber,
      'workExperiences': workExperiences
          .map(
            (e) => {
              'title': e.title,
              'company': e.company,
              'dateRange': e.dateRange,
              'description': e.description,
            },
          )
          .toList(),
      'skills': skills.map((e) => {'name': e}).toList(),
      'projects': projects
          .map(
            (e) => {
              'title': e.title,
              'description': e.description,
              'technologies': e.technologies,
            },
          )
          .toList(),
    };
  }
}
