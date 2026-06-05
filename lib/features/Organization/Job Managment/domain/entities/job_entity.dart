class JobItemEntity {
  final String id;
  final String title;
  final String type;
  final String? location;
  final String postedAt;
  final int applicantsCount;
  final String? description;
  final String? requirements;
  final String? careerLevel;
  final int? experienceYears;
  final List<String>? requiredSkills;
  final String? category;
  final String? subCategory;
  final String? startedAt;
  final String? endedAt;
  final int? cvCount;
  final int? codingCount;
  final int? behavioralCount;
  final int? technicalCount;

  JobItemEntity({
    required this.id,
    required this.title,
    required this.type,
    this.location,
    required this.postedAt,
    required this.applicantsCount,
    this.description,
    this.requirements,
    this.careerLevel,
    this.experienceYears,
    this.requiredSkills,
    this.category,
    this.subCategory,
    this.startedAt,
    this.endedAt,
    this.cvCount,
    this.codingCount,
    this.behavioralCount,
    this.technicalCount,
  });
}

class JobManagementEntity {
  final int activeJobs;
  final int totalApplicants;
  final List<JobItemEntity> jobs;

  JobManagementEntity({
    required this.activeJobs,
    required this.totalApplicants,
    required this.jobs,
  });
}
