import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';

class JobItemModel extends JobItemEntity {
  JobItemModel({
    required super.id,
    required super.title,
    required super.type,
    super.location,
    required super.postedAt,
    required super.applicantsCount,
    super.description,
    super.requirements,
    super.careerLevel,
    super.experienceYears,
    super.requiredSkills,
  });

  factory JobItemModel.fromJson(Map<String, dynamic> json) {
    return JobItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled',
      type: json['type'] ?? 'Full Time',

      // 🔴 مسكنا الـ Location (locations)
      location: json['locations'] ?? json['location'],

      postedAt: _formatDate(
        json['postedAt'] ?? json['startDateTime'] ?? json['createdAt'],
      ),
      applicantsCount: json['applicantsCount'] ?? json['applicants'] ?? 0,
      description: json['description'],

      // 🔴 مسكنا الـ Requirements (jobrequirements)
      requirements: json['jobrequirements'] ?? json['requirements'] ?? '',

      careerLevel: json['careerLevel'] ?? json['level'],

      experienceYears: _parseExperience(
        json['experienceYears'] ?? json['experience'],
      ),

      // 🔴 مسكنا الـ Skills (skillsAndTools)
      requiredSkills: _parseSkills(
        json['skillsAndTools'] ?? json['requiredSkills'],
      ),
    );
  }

  static int? _parseExperience(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final match = RegExp(r'(\d+)').firstMatch(value);
      return match != null ? int.tryParse(match.group(0)!) : null;
    }
    return null;
  }

  static List<String> _parseSkills(dynamic value) {
    if (value == null) return [];
    // لو راجعة لستة جاهزة
    if (value is List) return value.map((e) => e.toString()).toList();
    // لو راجعة نص مفصول بفاصلة
    if (value is String && value.isNotEmpty) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  static String _formatDate(String? isoDate) {
    if (isoDate == null) return "Recently";
    try {
      DateTime date = DateTime.parse(isoDate);
      List<String> months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "Posted ${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "Recently";
    }
  }
}

class JobManagementModel extends JobManagementEntity {
  JobManagementModel({
    required super.activeJobs,
    required super.totalApplicants,
    required super.jobs,
  });

  factory JobManagementModel.fromJson(Map<String, dynamic> json) {
    return JobManagementModel(
      activeJobs: json['activeJobs'] ?? 0,
      totalApplicants: json['totalApplicants'] ?? 0,
      jobs:
          (json['jobs'] as List?)
              ?.map((job) => JobItemModel.fromJson(job))
              .toList() ??
          [],
    );
  }
}
