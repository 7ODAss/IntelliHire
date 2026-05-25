import '../../domain/entities/home_entity.dart';

class DashboardJobModel extends DashboardJobEntity {
  DashboardJobModel({
    required super.id,
    required super.title,
    required super.postedAt,
    required super.acceptedCount,
    required super.rejectedCount,
  });

  factory DashboardJobModel.fromJson(Map<String, dynamic> json) {
    return DashboardJobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      postedAt: _formatDate(json['postedAt']), 
      acceptedCount: json['acceptedCount'] ?? 0,
      rejectedCount: json['rejectedCount'] ?? 0,
    );
  }

  // دالة صغيرة عشان نظبط شكل التاريخ
  static String _formatDate(String? isoDate) {
    if (isoDate == null) return "Recently";
    try {
      DateTime date = DateTime.parse(isoDate);
      List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      return "Posted ${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "Recently";
    }
  }
}

class HomeModel extends HomeEntity {
  HomeModel({
    required super.companyName,
    required super.interviewsCount,
    required super.totalCandidates,
    required super.pendingCandidates,
    required super.topTalentCandidatesCount,
    required super.topTalentInterviewsCount,
    required super.jobs,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      companyName: json['companyName'] ?? 'Company',
      interviewsCount: json['interviewsCount'] ?? 0,
      totalCandidates: json['totalCandidates'] ?? 0,
      pendingCandidates: json['pendingCandidates'] ?? 0,
      topTalentCandidatesCount: json['topTalentCandidatesCount'] ?? 0,
      topTalentInterviewsCount: json['topTalentInterviewsCount'] ?? 0,
      jobs: (json['jobs'] as List?)?.map((job) => DashboardJobModel.fromJson(job)).toList() ?? [],
    );
  }
}