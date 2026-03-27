part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool changeSuffix;
  final String selectedIndustry;
  final bool checkBoxTermsConditions;
  final String selectedCountry;
  final String selectedGovernorate;
  final int currentScreen;
  final RequestState signUpState;
  final String signUpMessage;
  final SignUpCompanyModel? signUpCompanyModel;


  const SignUpState({
    this.changeSuffix = true,
    this.checkBoxTermsConditions = false,
    this.selectedIndustry = '',
    this.selectedCountry= '',
    this.selectedGovernorate= '',
    this.currentScreen = 0,
    this.signUpState = RequestState.initial,
    this.signUpMessage = '',
    this.signUpCompanyModel,
  });

  SignUpState copyWith({
    bool? changeSuffix,
    bool? checkBoxTermsConditions,
    String? selectedIndustry,
    String? selectedCountry,
    String? selectedGovernorate,
    int? currentScreen,
    RequestState? signUpState,
    String? signUpMessage,
    SignUpCompanyModel? signUpCompanyModel,
  }) {
    return SignUpState(
      changeSuffix: changeSuffix ?? this.changeSuffix,
      checkBoxTermsConditions: checkBoxTermsConditions ?? this.checkBoxTermsConditions,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      currentScreen: currentScreen ?? this.currentScreen,
      signUpState: signUpState ?? this.signUpState,
      signUpMessage: signUpMessage ?? this.signUpMessage,
      signUpCompanyModel: signUpCompanyModel ?? this.signUpCompanyModel,
    );
  }

  @override
  List<Object?> get props => [
    changeSuffix,
    checkBoxTermsConditions,
    selectedIndustry,
    selectedCountry,
    selectedGovernorate,
    currentScreen,
    signUpState,
    signUpMessage,
    signUpCompanyModel,
  ];
}
