import 'package:intelli_hire/core/helpers/cache_helper.dart';

class ApplicantModel {
  // Static cache to store candidate score and photo by sessionId
  static final Map<String, Map<String, dynamic>> sessionCache = {};

  // Static set to track processed sessions (accepted/rejected) during the app run
  static final Set<String> processedSessionIds = {};
  static bool isProcessedSessionIdsLoaded = false;

  static Future<void> markSessionAsProcessed(String sessionId) async {
    processedSessionIds.add(sessionId);
    try {
      await CacheHelper.saveData(
        key: 'processed_session_ids',
        value: processedSessionIds.join(','),
      );
    } catch (e) {}
  }

  static Future<void> loadProcessedSessionIds() async {
    if (isProcessedSessionIdsLoaded) return;
    try {
      final String? savedIds = await CacheHelper.getData(
        key: 'processed_session_ids',
      );
      if (savedIds != null && savedIds.trim().isNotEmpty) {
        processedSessionIds.addAll(
          savedIds.split(',').map((s) => s.trim()).where((id) => id.isNotEmpty),
        );
      }
    } catch (e) {}
    isProcessedSessionIdsLoaded = true;
  }

  final String id;
  final String sessionId;
  final String name;
  final String role;
  final String? email;
  final String? phone;
  final int experienceYears;
  final double averageResponseTime;
  final double accuracyPercent;
  final int aiScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String status;
  final String? photo;

  ApplicantModel({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.role,
    this.email,
    this.phone,
    required this.experienceYears,
    required this.averageResponseTime,
    required this.accuracyPercent,
    required this.aiScore,
    required this.strengths,
    required this.weaknesses,
    required this.status,
    this.photo,
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    List<String> parsePoints(String? points) {
      if (points == null || points.trim() == "N/A" || points.isEmpty) return [];
      if (points.contains('|')) {
        return points
            .split('|')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return points
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        String clean = value.replaceAll(RegExp(r'[^\d.]'), '').trim();
        return double.tryParse(clean) ?? 0.0;
      }
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) {
        String clean = value.replaceAll(RegExp(r'[^\d]'), '').trim();
        return int.tryParse(clean) ?? 0;
      }
      return 0;
    }

    String parseStatus(dynamic value) {
      if (value == null) return 'Pending';
      if (value is int) {
        if (value == 1) return 'Accepted';
        if (value == 2) return 'Rejected';
        return 'Pending';
      }
      final str = value.toString().trim().toLowerCase();
      if (str == '0' || str == 'pending') return 'Pending';
      if (str == '1' || str == 'accepted') return 'Accepted';
      if (str == '2' || str == 'rejected') return 'Rejected';
      return value.toString().trim();
    }

    return ApplicantModel(
      id:
          json['sessionId'] ??
          json['SessionId'] ??
          json['id'] ??
          json['Id'] ??
          '',
      sessionId:
          json['sessionId'] ??
          json['SessionId'] ??
          json['id'] ??
          json['Id'] ??
          '',

      name: json['fullName'] ?? json['name'] ?? 'Unknown Candidate',

      role: json['currentRole'] ?? json['role'] ?? 'Candidate',

      email: json['email']?.toString(),
      phone: json['phone']?.toString(),

      experienceYears: parseInt(
        json['experienceYears'] ??
            json['ExperienceYears'] ??
            json['experience'] ??
            json['Experience'] ??
            json['yearsOfExperience'] ??
            json['YearsOfExperience'] ??
            json['yrsOfExperience'] ??
            json['experienceYrs'] ??
            0,
      ),
      averageResponseTime: parseDouble(
        json['averageResponseTime'] ?? json['avgResponseTime'] ?? 0,
      ),

      accuracyPercent: parseDouble(
        json['accuracyPercent'] ?? json['aiScore'] ?? 0,
      ),
      aiScore: (json['aiScore'] ?? json['accuracyPercent'] ?? 0).toInt(),

      strengths: parsePoints(json['strengthPoints']),
      weaknesses: parsePoints(
        json['weaknessesPoints'] ?? json['weaknessPoints'],
      ),
      status: parseStatus(json['status']),
      photo: json['photo']?.toString() ?? json['photoUrl']?.toString(),
    );
  }

  ApplicantModel copyWith({String? status, int? aiScore, String? photo}) {
    return ApplicantModel(
      id: id,
      sessionId: sessionId,
      name: name,
      role: role,
      email: email,
      phone: phone,
      experienceYears: experienceYears,
      averageResponseTime: averageResponseTime,
      accuracyPercent: accuracyPercent,
      aiScore: aiScore ?? this.aiScore,
      strengths: strengths,
      weaknesses: weaknesses,
      status: status ?? this.status,
      photo: photo ?? this.photo,
    );
  }
}
