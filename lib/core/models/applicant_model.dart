class ApplicantModel {
  // Static cache to store candidate score and photo by sessionId
  static final Map<String, Map<String, dynamic>> sessionCache = {};

  final String id;
  final String sessionId;
  final String name;
  final String role;
  final String? email; // 🔴 ضفنا الإيميل
  final String? phone; // 🔴 ضفنا التليفون
  final int experienceYears;
  final double averageResponseTime;
  final double accuracyPercent;
  final int aiScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String status;
  final String? photo; // 🔴 حقل الصورة

  ApplicantModel({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.role,
    this.email, // 🔴
    this.phone, // 🔴
    required this.experienceYears,
    required this.averageResponseTime,
    required this.accuracyPercent,
    required this.aiScore,
    required this.strengths,
    required this.weaknesses,
    required this.status,
    this.photo, // 🔴
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    print("ApplicantModel.fromJson raw JSON map for '${json['fullName'] ?? json['name'] ?? 'unknown'}': $json");

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
      final str = value.toString().trim();
      if (str == '0') return 'Pending';
      if (str == '1') return 'Accepted';
      if (str == '2') return 'Rejected';
      return str;
    }

    return ApplicantModel(
      id: json['sessionId'] ?? json['SessionId'] ?? json['id'] ?? json['Id'] ?? '',
      sessionId: json['sessionId'] ?? json['SessionId'] ?? json['id'] ?? json['Id'] ?? '',
      // 🔴 الباك إند بيبعت fullName بدل name
      name: json['fullName'] ?? json['name'] ?? 'Unknown Candidate',
      // 🔴 الباك إند بيبعت currentRole بدل role
      role: json['currentRole'] ?? json['role'] ?? 'Candidate',
 
      // 🔴 قراءة الإيميل والرقم
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
      ), // 🔴 عدلنا الاسم حسب الـ JSON
      status: parseStatus(json['status']),
      photo: json['photo']?.toString() ?? json['photoUrl']?.toString(),
    );
  }

  ApplicantModel copyWith({
    String? status,
    int? aiScore,
    String? photo,
  }) {
    return ApplicantModel(
      id: id,
      sessionId: sessionId,
      name: name,
      role: role,
      email: email, // 🔴
      phone: phone, // 🔴
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
