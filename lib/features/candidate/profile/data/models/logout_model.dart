import 'package:intelli_hire/features/candidate/profile/domain/entities/logout_candidate.dart';

class LogoutCandidateModel extends LogoutCandidate {
  LogoutCandidateModel({
    super.token,
    super.expiresOn,
    super.refreshToken,
    super.email,
    super.userType,
    super.isAuthenticated,
    super.message,
  });

  factory LogoutCandidateModel.fromJson(Map<String, dynamic> json) {
    return LogoutCandidateModel(
      token: json['token'] ?? '',
      expiresOn: json['expiresOn'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      isAuthenticated: json['isAuthenticated'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
