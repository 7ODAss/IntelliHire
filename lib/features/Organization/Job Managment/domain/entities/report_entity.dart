class ReportEntity {
  final String sessionId;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? averageResponseTime; 
  final double? accuracyPercent;
  final String? strengthPoints;
  final String? weaknessesPoints;
  final String? photo;

  ReportEntity({
    required this.sessionId,
    this.fullName,
    this.email,
    this.phone,
    this.averageResponseTime,
    this.accuracyPercent,
    this.strengthPoints,
    this.weaknessesPoints,
    this.photo,
  });
}