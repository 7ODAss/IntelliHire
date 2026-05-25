abstract class ExternalLoginState {}

class ExternalLoginInitial extends ExternalLoginState {}

class ExternalLoginLoading extends ExternalLoginState {
  final String provider;
  ExternalLoginLoading(this.provider);
}

class ExternalLoginSuccess extends ExternalLoginState {
  final String token;
  final bool isProfileComplete; 
  ExternalLoginSuccess(this.token, this.isProfileComplete);
}

class ExternalLoginFailure extends ExternalLoginState {
  final String errorMsg;
  ExternalLoginFailure(this.errorMsg);
}