abstract class ProfileSetupState {}

class ProfileInitial extends ProfileSetupState {}

class ProfileFilePicked extends ProfileSetupState {}

class ProfileUploading extends ProfileSetupState {
  final double progress; 
  ProfileUploading(this.progress);
}

class ProfileSuccess extends ProfileSetupState {}

class ProfileError extends ProfileSetupState {
  final String errorMsg;
  ProfileError(this.errorMsg);
}
