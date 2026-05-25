class SignUpCompanyModel {
  final String email;
  final String userType;
  final String token;
  final String refreshToken;
  final String expiresOn;
  final bool isSuccess;
  final String message;

  SignUpCompanyModel({
    required this.email,
    required this.userType,
    required this.token,
    required this.refreshToken,
    required this.expiresOn,
    required this.isSuccess,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userType': userType,
      'token': token,
      'refreshToken': refreshToken,
      'expiresOn': expiresOn,
      'isSuccess': isSuccess,
      'message': message,
    };
  }

  factory SignUpCompanyModel.fromJson(Map<String, dynamic> json) {
    return SignUpCompanyModel(
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresOn: json['expiresOn'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
