class LogoutCandidate {
  final String? token;
  final String? expiresOn;
  final String? refreshToken;
  final String? email;
  final String? userType;
  final bool? isAuthenticated;
  final String? message;

  LogoutCandidate({
    this.token,
    this.expiresOn,
    this.refreshToken,
    this.email,
    this.userType,
    this.isAuthenticated,
    this.message,
  });

}
