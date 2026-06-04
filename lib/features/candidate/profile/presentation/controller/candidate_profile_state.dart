part of 'candidate_profile_cubit.dart';

class CandidateProfileState extends Equatable {
  final RequestState status;
  final RequestState changePasswordStatus;
  final String changePasswordMessage;
  final CandidateProfile? candidateProfileModel;
  final RequestState candidateProfileStatus;
  final String candidateProfileMessage;
  final RequestState deleteAccountStatus;
  final String deleteAccountMessage;
  final RequestState changeCareerDetailsStatus;
  final String changeCareerDetailsMessage;
  final RequestState? userProfileCandidateLogOutState;
  final String? userProfileCandidateLogOutMessage;
  final File? selectedCvFile;
  final RequestState cvUploadStatus;
  final double cvUploadProgress;
  final String cvErrorMessage;
  final bool obsecure;
  final RequestState changePersonalInfoState;
  final String changePersonalInfoMessage;
  final RequestState changeEmailPasswordCheckState;
  final String changeEmailPasswordCheckMessage;
  final RequestState changeEmailEmailCheckState;
  final String changeEmailEmailCheckMessage;
  final RequestState otpState;
  final String otpMessage;

  const CandidateProfileState({
    this.status = RequestState.initial,
    this.changePasswordStatus = RequestState.initial,
    this.changePasswordMessage = '',
    this.candidateProfileModel,
    this.candidateProfileStatus = RequestState.initial,
    this.candidateProfileMessage = '',
    this.deleteAccountStatus = RequestState.initial,
    this.deleteAccountMessage = '',
    this.changeCareerDetailsStatus = RequestState.initial,
    this.changeCareerDetailsMessage = '',
    this.userProfileCandidateLogOutState,
    this.userProfileCandidateLogOutMessage,
    this.selectedCvFile,
    this.cvUploadStatus = RequestState.initial,
    this.cvUploadProgress = 0.0,
    this.cvErrorMessage = '',
    this.obsecure = true,
    this.changePersonalInfoState = RequestState.initial,
    this.changePersonalInfoMessage = '',
    this.changeEmailPasswordCheckState = RequestState.initial,
    this.changeEmailPasswordCheckMessage = '',
    this.changeEmailEmailCheckState = RequestState.initial,
    this.changeEmailEmailCheckMessage = '',
    this.otpState = RequestState.initial,
    this.otpMessage = '',
  });

  CandidateProfileState copyWith({
    RequestState? status,
    RequestState? changePasswordStatus,
    String? changePasswordMessage,
    CandidateProfile? candidateProfileModel,
    String? candidateProfileMessage,
    RequestState? candidateProfileStatus,
    RequestState? deleteAccountStatus,
    String? deleteAccountMessage,
    RequestState? changeCareerDetailsStatus,
    String? changeCareerDetailsMessage,
    RequestState? userProfileCandidateLogOutState,
    String? userProfileCandidateLogOutMessage,
    File? selectedCvFile,
    RequestState? cvUploadStatus,
    double? cvUploadProgress,
    String? cvErrorMessage,
    bool clearCvFile =
        false, // حيلة عشان نقدر نخلي الملف بـ null لو اليوزر مسحه
    bool? obsecure,
    RequestState? changePersonalInfoState,
    String? changePersonalInfoMessage,
    RequestState? changeEmailPasswordCheckState,
    String? changeEmailPasswordCheckMessage,
    RequestState? changeEmailEmailCheckState,
    String? changeEmailEmailCheckMessage,
    RequestState? otpState,
    String? otpMessage,
  }) => CandidateProfileState(
    status: status ?? this.status,
    changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
    changePasswordMessage: changePasswordMessage ?? this.changePasswordMessage,
    candidateProfileModel: candidateProfileModel ?? this.candidateProfileModel,
    candidateProfileStatus:
        candidateProfileStatus ?? this.candidateProfileStatus,
    candidateProfileMessage:
        candidateProfileMessage ?? this.candidateProfileMessage,
    deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
    deleteAccountMessage: deleteAccountMessage ?? this.deleteAccountMessage,
    changeCareerDetailsStatus:
        changeCareerDetailsStatus ?? this.changeCareerDetailsStatus,
    changeCareerDetailsMessage:
        changeCareerDetailsMessage ?? this.changeCareerDetailsMessage,
    userProfileCandidateLogOutState:
        userProfileCandidateLogOutState ?? this.userProfileCandidateLogOutState,
    userProfileCandidateLogOutMessage:
        userProfileCandidateLogOutMessage ??
        this.userProfileCandidateLogOutMessage,
    selectedCvFile: clearCvFile
        ? null
        : (selectedCvFile ?? this.selectedCvFile),
    cvUploadStatus: cvUploadStatus ?? this.cvUploadStatus,
    cvUploadProgress: cvUploadProgress ?? this.cvUploadProgress,
    cvErrorMessage: cvErrorMessage ?? this.cvErrorMessage,
    obsecure: obsecure ?? this.obsecure,
    changeEmailPasswordCheckState:
        changeEmailPasswordCheckState ?? this.changeEmailPasswordCheckState,
    changeEmailPasswordCheckMessage:
        changeEmailPasswordCheckMessage ?? this.changeEmailPasswordCheckMessage,
    changeEmailEmailCheckState:
        changeEmailEmailCheckState ?? this.changeEmailEmailCheckState,
    changeEmailEmailCheckMessage:
        changeEmailEmailCheckMessage ?? this.changeEmailEmailCheckMessage,
    otpState: otpState ?? this.otpState,
    otpMessage: otpMessage ?? this.otpMessage,
    changePersonalInfoState:
        changePersonalInfoState ?? this.changePersonalInfoState,
    changePersonalInfoMessage:
        changePersonalInfoMessage ?? this.changePersonalInfoMessage,
  );

  @override
  List<Object?> get props => [
    status,
    changePasswordStatus,
    candidateProfileModel,
    changePasswordMessage,
    deleteAccountStatus,
    deleteAccountMessage,
    changeCareerDetailsStatus,
    changeCareerDetailsMessage,
    userProfileCandidateLogOutState,
    userProfileCandidateLogOutMessage,
    selectedCvFile,
    cvUploadStatus,
    cvUploadProgress,
    cvErrorMessage,
    obsecure,
    changePersonalInfoState,
    changePersonalInfoMessage,
    changeEmailPasswordCheckState,
    changeEmailPasswordCheckMessage,
    changeEmailEmailCheckState,
    changeEmailEmailCheckMessage,
    otpState,
    otpMessage,
  ];
}
