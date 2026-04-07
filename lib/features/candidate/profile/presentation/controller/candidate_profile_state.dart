part of 'candidate_profile_cubit.dart';

class CandidateProfileState extends Equatable {
  final RequestState status;
  final RequestState changePasswordStatus;
  final CandidateProfile? profile;
  final String errorMessage;

  const CandidateProfileState({
    this.status = RequestState.initial,
    this.changePasswordStatus = RequestState.initial,
    this.profile,
    this.errorMessage = '',
  });

  CandidateProfileState copyWith({
    RequestState? status,
    RequestState? changePasswordStatus,
    CandidateProfile? profile,
    String? errorMessage,
  }) =>
      CandidateProfileState(
        status: status ?? this.status,
        changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
        profile: profile ?? this.profile,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, changePasswordStatus, profile, errorMessage];
}
