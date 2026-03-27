class SignUpCompanyModel {
  final String email;
  final String userType;
  final String token;
  final String refreshToken;
  final String expiresOn;
  final bool isAuthenticated;
  final String message;

  SignUpCompanyModel({
    required this.email,
    required this.userType,
    required this.token,
    required this.refreshToken,
    required this.expiresOn,
    required this.isAuthenticated,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userType': userType,
      'token': token,
      'refreshToken': refreshToken,
      'expiresOn': expiresOn,
      'isAuthenticated': isAuthenticated,
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
      isAuthenticated: json['isAuthenticated'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
