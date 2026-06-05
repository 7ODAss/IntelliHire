class LoginModel {
  final String email;
  final String userType;
  final bool isSuccess;
  final String token;
  final String refreshToken;
  final DateTime expiresOn;
  final String message;
  final bool isProfileComplete; 

  LoginModel({
    required this.token,
    required this.expiresOn,
    required this.refreshToken,
    required this.email,
    required this.userType,
    required this.isSuccess,
    required this.message,
    required this.isProfileComplete, 
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      expiresOn: json['expiresOn'] != null
          ? DateTime.parse(json['expiresOn'].toString()).toLocal()
          : DateTime.now(),
      refreshToken: json['refreshToken'],
      email: json['email'],
      userType: json['userType'],
      isSuccess: json['isSuccess'],
      message: json['message'],
      isProfileComplete: json['isComplete'] ?? true, 
    );
  }
}