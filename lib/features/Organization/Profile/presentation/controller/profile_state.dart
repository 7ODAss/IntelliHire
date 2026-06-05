part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final String? detailedAddress;
  final String? websiteLink;
  final String? aboutCompany;
  final String? selectedCountry;
  final String? selectedGovernorate;
  final String? selectedIndustry;
  final List<CompanyLocation>? locations;
  final RequestState? changeAccountDetailsState;
  final String? changeAccountDetailsMessage;
  final RequestState? changeAboutCompanyState;
  final String? changeAboutCompanyMessage;
  final RequestState? changePasswordCompanyState;
  final String? changePasswordCompanyMessage;
  final RequestState? userProfileLogOutState;
  final String? userProfileLogOutMessage;

  // Change Email Flow States
  final RequestState? changeEmailPasswordCheckState;
  final String? changeEmailPasswordCheckMessage;
  final RequestState? changeEmailEmailCheckState;
  final String? changeEmailEmailCheckMessage;
  final RequestState? otpState;
  final String? otpMessage;
  final bool obsecure;
  final String? companyEmail;

  // Company Account Fetching State
  final RequestState? getCompanyAccountState;
  final String? getCompanyAccountMessage;
  final CompanyAccountModel? companyAccount;

  // Change Password Flow States (New)
  final RequestState? changePasswordRequestState;
  final String? changePasswordRequestMessage;
  final RequestState? changePasswordOtpState;
  final String? changePasswordOtpMessage;
  final String? pendingCurrentPassword;
  final String? pendingNewPassword;
  final String? passwordChangeToken;

  // Delete Account States (New)
  final RequestState? deleteAccountState;
  final String? deleteAccountMessage;

  const ProfileState({
    this.detailedAddress,
    this.websiteLink,
    this.aboutCompany,
    this.selectedCountry,
    this.selectedGovernorate,
    this.selectedIndustry,
    this.locations,
    this.changeAccountDetailsState,
    this.changeAccountDetailsMessage,
    this.changeAboutCompanyState,
    this.changeAboutCompanyMessage,
    this.changePasswordCompanyState,
    this.changePasswordCompanyMessage,
    this.userProfileLogOutState,
    this.userProfileLogOutMessage,
    
    this.changeEmailPasswordCheckState = RequestState.initial,
    this.changeEmailPasswordCheckMessage = '',
    this.changeEmailEmailCheckState = RequestState.initial,
    this.changeEmailEmailCheckMessage = '',
    this.otpState = RequestState.initial,
    this.otpMessage = '',
    this.obsecure = true,
    this.companyEmail,

    this.getCompanyAccountState = RequestState.initial,
    this.getCompanyAccountMessage = '',
    this.companyAccount,

    this.changePasswordRequestState = RequestState.initial,
    this.changePasswordRequestMessage = '',
    this.changePasswordOtpState = RequestState.initial,
    this.changePasswordOtpMessage = '',
    this.pendingCurrentPassword = '',
    this.pendingNewPassword = '',
    this.passwordChangeToken = '',

    this.deleteAccountState = RequestState.initial,
    this.deleteAccountMessage = '',
  });

  ProfileState copyWith({
    String? detailedAddress,
    String? websiteLink,
    String? aboutCompany,
    String? selectedCountry,
    String? selectedGovernorate,
    String? selectedIndustry,
    List<CompanyLocation>? locations,
    RequestState? changeAccountDetailsState,
    String? changeAccountDetailsMessage,
    RequestState? changeAboutCompanyState,
    String? changeAboutCompanyMessage,
    RequestState? changePasswordCompanyState,
    String? changePasswordCompanyMessage,
    RequestState? userProfileLogOutState,
    String? userProfileLogOutMessage,
    
    RequestState? changeEmailPasswordCheckState,
    String? changeEmailPasswordCheckMessage,
    RequestState? changeEmailEmailCheckState,
    String? changeEmailEmailCheckMessage,
    RequestState? otpState,
    String? otpMessage,
    bool? obsecure,
    String? companyEmail,

    RequestState? getCompanyAccountState,
    String? getCompanyAccountMessage,
    CompanyAccountModel? companyAccount,

    RequestState? changePasswordRequestState,
    String? changePasswordRequestMessage,
    RequestState? changePasswordOtpState,
    String? changePasswordOtpMessage,
    String? pendingCurrentPassword,
    String? pendingNewPassword,
    String? passwordChangeToken,

    RequestState? deleteAccountState,
    String? deleteAccountMessage,
  }) {
    return ProfileState(
      detailedAddress: detailedAddress ?? this.detailedAddress,
      websiteLink: websiteLink ?? this.websiteLink,
      aboutCompany: aboutCompany ?? this.aboutCompany,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      locations: locations ?? this.locations,
      changeAccountDetailsState: changeAccountDetailsState ?? this.changeAccountDetailsState,
      changeAccountDetailsMessage: changeAccountDetailsMessage ?? this.changeAccountDetailsMessage,
      changeAboutCompanyState: changeAboutCompanyState ?? this.changeAboutCompanyState,
      changeAboutCompanyMessage: changeAboutCompanyMessage ?? this.changeAboutCompanyMessage,
      changePasswordCompanyState: changePasswordCompanyState ?? this.changePasswordCompanyState,
      changePasswordCompanyMessage: changePasswordCompanyMessage ?? this.changePasswordCompanyMessage,
      userProfileLogOutState: userProfileLogOutState ?? this.userProfileLogOutState,
      userProfileLogOutMessage: userProfileLogOutMessage ?? this.userProfileLogOutMessage,
      
      changeEmailPasswordCheckState: changeEmailPasswordCheckState ?? this.changeEmailPasswordCheckState,
      changeEmailPasswordCheckMessage: changeEmailPasswordCheckMessage ?? this.changeEmailPasswordCheckMessage,
      changeEmailEmailCheckState: changeEmailEmailCheckState ?? this.changeEmailEmailCheckState,
      changeEmailEmailCheckMessage: changeEmailEmailCheckMessage ?? this.changeEmailEmailCheckMessage,
      otpState: otpState ?? this.otpState,
      otpMessage: otpMessage ?? this.otpMessage,
      obsecure: obsecure ?? this.obsecure,
      companyEmail: companyEmail ?? this.companyEmail,

      getCompanyAccountState: getCompanyAccountState ?? this.getCompanyAccountState,
      getCompanyAccountMessage: getCompanyAccountMessage ?? this.getCompanyAccountMessage,
      companyAccount: companyAccount ?? this.companyAccount,

      changePasswordRequestState: changePasswordRequestState ?? this.changePasswordRequestState,
      changePasswordRequestMessage: changePasswordRequestMessage ?? this.changePasswordRequestMessage,
      changePasswordOtpState: changePasswordOtpState ?? this.changePasswordOtpState,
      changePasswordOtpMessage: changePasswordOtpMessage ?? this.changePasswordOtpMessage,
      pendingCurrentPassword: pendingCurrentPassword ?? this.pendingCurrentPassword,
      pendingNewPassword: pendingNewPassword ?? this.pendingNewPassword,
      passwordChangeToken: passwordChangeToken ?? this.passwordChangeToken,

      deleteAccountState: deleteAccountState ?? this.deleteAccountState,
      deleteAccountMessage: deleteAccountMessage ?? this.deleteAccountMessage,
    );
  }

  @override
  List<Object?> get props => [
    detailedAddress,
    websiteLink,
    aboutCompany,
    selectedCountry,
    selectedGovernorate,
    selectedIndustry,
    locations,
    changeAccountDetailsState,
    changeAccountDetailsMessage,
    changeAboutCompanyState,
    changeAboutCompanyMessage,
    changePasswordCompanyState,
    changePasswordCompanyMessage,
    userProfileLogOutState,
    userProfileLogOutMessage,
    
    changeEmailPasswordCheckState,
    changeEmailPasswordCheckMessage,
    changeEmailEmailCheckState,
    changeEmailEmailCheckMessage,
    otpState,
    otpMessage,
    obsecure,
    companyEmail,

    getCompanyAccountState,
    getCompanyAccountMessage,
    companyAccount,

    changePasswordRequestState,
    changePasswordRequestMessage,
    changePasswordOtpState,
    changePasswordOtpMessage,
    pendingCurrentPassword,
    pendingNewPassword,
    passwordChangeToken,

    deleteAccountState,
    deleteAccountMessage,
  ];
}
