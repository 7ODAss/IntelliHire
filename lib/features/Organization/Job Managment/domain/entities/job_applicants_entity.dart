class BasicApplicantEntity {
  final String sessionId;
  final String fullName;
  final String? currentRole;
  final double? overallScore;
  final String? status;

  BasicApplicantEntity({
    required this.sessionId,
    required this.fullName,
    this.currentRole,
    this.overallScore,
    this.status,
  });
}

class JobApplicantsListEntity {
  final int totalApplicants;
  final String? topScorerName;
  final double? topScore;
  final List<BasicApplicantEntity> applicants;

  JobApplicantsListEntity({
    required this.totalApplicants,
    this.topScorerName,
    this.topScore,
    required this.applicants,
  });
}
