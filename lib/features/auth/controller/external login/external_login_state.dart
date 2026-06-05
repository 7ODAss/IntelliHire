abstract class ExternalLoginState {}

class ExternalLoginInitial extends ExternalLoginState {}

class ExternalLoginLoading extends ExternalLoginState {
  final String provider;
  ExternalLoginLoading(this.provider);
}

class ExternalLoginSuccess extends ExternalLoginState {
  final String token;
  final bool isProfileComplete;
  final String userType; 
  ExternalLoginSuccess(this.token, this.isProfileComplete, this.userType);
}

class ExternalLoginFailure extends ExternalLoginState {
  final String error;
  ExternalLoginFailure(this.error);
}