part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool changePasswordSuffix;
  final bool changeConfirmPasswordSuffix;
  final String workPhone;
  final String companyName;
  final String industry;
  final String country;
  final String gov;
  final String address;
  final String photoCompany;
  final String linkCompany;
  final String aboutCompany;
  final String selectedIndustry;
  final bool checkBoxTermsConditions;
  final String selectedCountry;
  final String selectedGovernorate;
  final int currentScreen;
  final RequestState signUpState;
  final String signUpMessage;
  final SignUpCompanyModel? signUpCompanyModel;
  final RequestState completeSignUpState;
  final String completeSignUpMessage;
  final SignUpCompanyModel? completeSignUpCompanyModel;
  final RequestState confirmEmailState;
  final String confirmEmailMessage;
  final String userType;

  const SignUpState({
    this.changePasswordSuffix = true,
    this.changeConfirmPasswordSuffix = true,
    this.workPhone = '',
    this.companyName = '',
    this.industry = '',
    this.country = '',
    this.gov = '',
    this.address = '',
    this.photoCompany = '',
    this.linkCompany = '',
    this.aboutCompany = '',
    this.checkBoxTermsConditions = false,
    this.selectedIndustry = '',
    this.selectedCountry = '',
    this.selectedGovernorate = '',
    this.currentScreen = 0,
    this.signUpState = RequestState.initial,
    this.signUpMessage = '',
    this.signUpCompanyModel,
    this.completeSignUpState = RequestState.initial,
    this.completeSignUpMessage = '',
    this.completeSignUpCompanyModel,
    this.confirmEmailState = RequestState.initial,
    this.confirmEmailMessage = '',
    this.userType = '',
  });

  SignUpState copyWith({
    bool? changePasswordSuffix,
    bool? changeConfirmPasswordSuffix,
    String? workPhone,
    String? companyName,
    String? industry,
    String? country,
    String? gov,
    String? address,
    String? photoCompany,
    String? linkCompany,
    String? aboutCompany,
    bool? checkBoxTermsConditions,
    String? selectedIndustry,
    String? selectedCountry,
    String? selectedGovernorate,
    int? currentScreen,
    RequestState? signUpState,
    String? signUpMessage,
    SignUpCompanyModel? signUpCompanyModel,
    RequestState? completeSignUpState,
    String? completeSignUpMessage,
    SignUpCompanyModel? completeSignUpCompanyModel,
    RequestState? confirmEmailState,
    String? confirmEmailMessage,
    String? userType,
  }) {
    return SignUpState(
      changePasswordSuffix: changePasswordSuffix ?? this.changePasswordSuffix,
      changeConfirmPasswordSuffix: changeConfirmPasswordSuffix ?? this.changeConfirmPasswordSuffix,
      workPhone: workPhone ?? this.workPhone,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      country: country ?? this.country,
      gov: gov ?? this.gov,
      address: address ?? this.address,
      photoCompany: photoCompany ?? this.photoCompany,
      linkCompany: linkCompany ?? this.linkCompany,
      aboutCompany: aboutCompany ?? this.aboutCompany,
      checkBoxTermsConditions: checkBoxTermsConditions ?? this.checkBoxTermsConditions,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      currentScreen: currentScreen ?? this.currentScreen,
      signUpState: signUpState ?? this.signUpState,
      signUpMessage: signUpMessage ?? this.signUpMessage,
      signUpCompanyModel: signUpCompanyModel ?? this.signUpCompanyModel,
      completeSignUpState: completeSignUpState ?? this.completeSignUpState,
      completeSignUpMessage:
          completeSignUpMessage ?? this.completeSignUpMessage,
      completeSignUpCompanyModel:
          completeSignUpCompanyModel ?? this.completeSignUpCompanyModel,
      confirmEmailState: confirmEmailState ?? this.confirmEmailState,
      confirmEmailMessage: confirmEmailMessage ?? this.confirmEmailMessage,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
    changePasswordSuffix,
    changeConfirmPasswordSuffix,
    workPhone,
    companyName,
    industry,
    country,
    gov,
    address,
    checkBoxTermsConditions,
    selectedIndustry,
    selectedCountry,
    selectedGovernorate,
    currentScreen,
    signUpState,
    signUpMessage,
    signUpCompanyModel,
    completeSignUpState,
    completeSignUpMessage,
    completeSignUpCompanyModel,
    confirmEmailState,
    confirmEmailMessage,
    userType,
  ];
}
