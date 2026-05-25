import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';

class LogoutModel extends Logout {
  LogoutModel({
    super.token,
    super.expiresOn,
    super.refreshToken,
    super.email,
    super.userType,
    super.isSuccess,
    super.message,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      token: json['token'] ?? '',
      expiresOn: json['expiresOn'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
