import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/project.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/work_experience.dart';

class CvData extends Equatable {
  final String id;
  final String fullName;
  final String jobTitle;
  final String email;
  final String phoneNumber;
  final List<WorkExperience> workExperiences;
  final List<String> skills;
  final List<Project> projects;

  const CvData({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phoneNumber,
    required this.workExperiences,
    required this.skills,
    required this.projects,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    jobTitle,
    email,
    phoneNumber,
    workExperiences,
    skills,
    projects,
  ];
}
