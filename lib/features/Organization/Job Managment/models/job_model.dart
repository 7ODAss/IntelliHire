class JobModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final String jobType;
  final int candidatesCount;
  final String? description;
  final String? requirements;
  final String? careerLevel;
  final String? experience;
  final List<String>? skills;

  JobModel({
    required this.title,
    required this.location,
    required this.date,
    required this.jobType,
    this.candidatesCount = 0,
    required this.id,
    this.description,
    this.requirements,
    this.careerLevel,
    this.experience,
    this.skills,
  });
}
