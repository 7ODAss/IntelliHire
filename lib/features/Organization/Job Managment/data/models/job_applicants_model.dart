import '../../domain/entities/job_applicants_entity.dart';

class BasicApplicantModel extends BasicApplicantEntity {
  BasicApplicantModel({
    required super.sessionId,
    required super.fullName,
    super.currentRole,
    super.overallScore,
    super.status,
  });

  factory BasicApplicantModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    int statusCode = 0;
    if (rawStatus is int) {
      statusCode = rawStatus;
    } else if (rawStatus != null) {
      final strStatus = rawStatus.toString().trim().toLowerCase();
      if (strStatus == '1' || strStatus == 'accepted') {
        statusCode = 1;
      } else if (strStatus == '2' || strStatus == 'rejected') {
        statusCode = 2;
      }
    }
    String mappedStatus = "Pending";

    if (statusCode == 0) {
      mappedStatus = "Pending";
    } else if (statusCode == 1) {
      mappedStatus = "Accepted";
    } else if (statusCode == 2) {
      mappedStatus = "Rejected";
    }

    // 2. قراءة الـ المسمى الوظيفي بناءً على اللي راجع من الباك إند
    final roleValue = json['currentRole'] ?? json['jobTitle'];

    // 3. قراءة التقييم
    final scoreValue = json['overallScore'] ?? json['score'];

    return BasicApplicantModel(
      sessionId: json['sessionId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? 'Unknown Applicant',
      currentRole: roleValue?.toString() ?? 'Candidate',
      overallScore: scoreValue != null
          ? double.tryParse(scoreValue.toString())
          : null,
      status: mappedStatus, // 🔴 بنمرر الحالة بعد ما حولناها لكلمة
    );
  }
}

class JobApplicantsListModel extends JobApplicantsListEntity {
  JobApplicantsListModel({
    required super.totalApplicants,
    super.topScorerName,
    super.topScore,
    required super.applicants,
  });

  factory JobApplicantsListModel.fromJson(Map<String, dynamic> json) {
    return JobApplicantsListModel(
      totalApplicants: json['totalApplicants'] != null
          ? int.tryParse(json['totalApplicants'].toString()) ?? 0
          : 0,
      topScorerName: json['topScorerName']?.toString(),
      topScore: json['topScore'] != null
          ? double.tryParse(json['topScore'].toString())
          : null,
      applicants:
          (json['applicants'] as List?)
              ?.map((e) => BasicApplicantModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
