class LoginModel {
  final String email;
  final String userType;
  final bool isAuthenticated;
  final String token;
  final String refreshToken;
  final String expiresOn;
  final String message;

  LoginModel({
   required this.token,
   required this.expiresOn,
   required this.refreshToken,
   required this.email,
   required this.userType,
   required this.isAuthenticated,
   required this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      expiresOn: json['expiresOn'],
      refreshToken: json['refreshToken'],
      email: json['email'],
      userType: json['userType'],
      isAuthenticated: json['isAuthenticated'],
      message: json['message'],
    );
  }
}
