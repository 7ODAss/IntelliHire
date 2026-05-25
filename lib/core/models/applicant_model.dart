class ApplicantModel {
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

    return ApplicantModel(
      id: json['sessionId'] ?? '',
      sessionId: json['sessionId'] ?? '',
      // 🔴 الباك إند بيبعت fullName بدل name
      name: json['fullName'] ?? json['name'] ?? 'Unknown Candidate',
      // 🔴 الباك إند بيبعت currentRole بدل role
      role: json['currentRole'] ?? json['role'] ?? 'Candidate',

      // 🔴 قراءة الإيميل والرقم
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),

      experienceYears: json['experienceYears'] ?? 0,
      averageResponseTime:
          (json['averageResponseTime'] ?? json['avgResponseTime'] ?? 0)
              .toDouble(),

      accuracyPercent: (json['accuracyPercent'] ?? json['aiScore'] ?? 0)
          .toDouble(),
      aiScore: (json['aiScore'] ?? json['accuracyPercent'] ?? 0).toInt(),

      strengths: parsePoints(json['strengthPoints']),
      weaknesses: parsePoints(
        json['weaknessesPoints'] ?? json['weaknessPoints'],
      ), // 🔴 عدلنا الاسم حسب الـ JSON
      status: json['status'] ?? 'Pending',
    );
  }

  ApplicantModel copyWith({String? status}) {
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
      aiScore: aiScore,
      strengths: strengths,
      weaknesses: weaknesses,
      status: status ?? this.status,
    );
  }
}
