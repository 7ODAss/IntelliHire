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
  final RequestState changeEmailOtpState;
  final String changeEmailOtpMessage;

  final RequestState changePasswordOtpRequestState;
  final String changePasswordOtpRequestMessage;
  final String changePasswordOtpCheckToken;
  final RequestState changePasswordOtpCheckState;
  final String changePasswordOtpCheckMessage;
  final RequestState changePasswordVerifyState;
  final String changePasswordVerifyMessage;

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
    this.changeEmailOtpState = RequestState.initial,
    this.changeEmailOtpMessage = '',
    this.changePasswordOtpRequestState = RequestState.initial,
    this.changePasswordOtpRequestMessage = '',
    this.changePasswordOtpCheckToken = '',
    this.changePasswordOtpCheckState = RequestState.initial,
    this.changePasswordOtpCheckMessage = '',
    this.changePasswordVerifyState = RequestState.initial,
    this.changePasswordVerifyMessage = '',
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
    RequestState? changeEmailOtpState,
    String? changeEmailOtpMessage,
    RequestState? changePasswordOtpRequestState,
    String? changePasswordOtpRequestMessage,
    String? changePasswordOtpCheckToken,
    RequestState? changePasswordOtpCheckState,
    String? changePasswordOtpCheckMessage,
    RequestState? changePasswordVerifyState,
    String? changePasswordVerifyMessage,
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
    changeEmailOtpState: changeEmailOtpState ?? this.changeEmailOtpState,
    changeEmailOtpMessage: changeEmailOtpMessage ?? this.changeEmailOtpMessage,
    changePersonalInfoState:
        changePersonalInfoState ?? this.changePersonalInfoState,
    changePersonalInfoMessage:
        changePersonalInfoMessage ?? this.changePersonalInfoMessage,
    changePasswordOtpRequestState:
        changePasswordOtpRequestState ?? this.changePasswordOtpRequestState,
    changePasswordOtpRequestMessage:
        changePasswordOtpRequestMessage ?? this.changePasswordOtpRequestMessage,
    changePasswordOtpCheckToken:
        changePasswordOtpCheckToken ?? this.changePasswordOtpCheckToken,
    changePasswordOtpCheckState:
        changePasswordOtpCheckState ?? this.changePasswordOtpCheckState,
    changePasswordOtpCheckMessage:
        changePasswordOtpCheckMessage ?? this.changePasswordOtpCheckMessage,
    changePasswordVerifyState:
        changePasswordVerifyState ?? this.changePasswordVerifyState,
    changePasswordVerifyMessage:
        changePasswordVerifyMessage ?? this.changePasswordVerifyMessage,
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
    changeEmailOtpState,
    changeEmailOtpMessage,
    changePasswordOtpRequestState,
    changePasswordOtpRequestMessage,
    changePasswordOtpCheckToken,
    changePasswordOtpCheckState,
    changePasswordOtpCheckMessage,
    changePasswordVerifyState,
    changePasswordVerifyMessage,
  ];
}
