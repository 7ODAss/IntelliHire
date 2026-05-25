class DashboardJobEntity {
  final String id;
  final String title;
  final String postedAt;
  final int acceptedCount;
  final int rejectedCount;

  DashboardJobEntity({
    required this.id,
    required this.title,
    required this.postedAt,
    required this.acceptedCount,
    required this.rejectedCount,
  });
}

class HomeEntity {
  final String companyName;
  final int interviewsCount; 
  final int totalCandidates;
  final int pendingCandidates;
  final int topTalentCandidatesCount;
  final int topTalentInterviewsCount;
  final List<DashboardJobEntity> jobs;

  HomeEntity({
    required this.companyName,
    required this.interviewsCount,
    required this.totalCandidates,
    required this.pendingCandidates,
    required this.topTalentCandidatesCount,
    required this.topTalentInterviewsCount,
    required this.jobs,
  });
}