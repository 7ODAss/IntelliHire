import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  ReportModel({
    required super.sessionId,
    super.fullName,
    super.email,
    super.phone,
    super.averageResponseTime,
    super.accuracyPercent,
    super.strengthPoints,
    super.weaknessesPoints,
    super.photo,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      sessionId: json['sessionId']?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      averageResponseTime: json['averageResponseTime']?.toString(),
      accuracyPercent: (json['accuracyPercent'] as num?)?.toDouble(),
      strengthPoints: json['strengthPoints']?.toString(),
      weaknessesPoints: json['weaknessesPoints']?.toString(),
      photo: json['photo']?.toString() ?? json['photoUrl']?.toString(),
    );
  }
}
