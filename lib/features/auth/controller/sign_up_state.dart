part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool changeSuffix;
  final bool checkBoxTermsConditions;
  final String? selectedCountry;
  final String? selectedGovernorate;
  final int currentScreen;

  const SignUpState({
    this.changeSuffix = true,
    this.checkBoxTermsConditions = false,
    this.selectedCountry,
    this.selectedGovernorate,
    this.currentScreen = 0,
  });

  SignUpState copyWith({
    bool? changeSuffix,
    bool? checkBoxTermsConditions,
    String? selectedCountry,
    String? selectedGovernorate,
    int? currentScreen,
  }) {
    return SignUpState(
      changeSuffix: changeSuffix ?? this.changeSuffix,
      checkBoxTermsConditions:
          checkBoxTermsConditions ?? this.checkBoxTermsConditions,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      currentScreen: currentScreen ?? this.currentScreen,
    );
  }

  @override
  List<Object?> get props => [
    changeSuffix,
    checkBoxTermsConditions,
    selectedCountry,
    selectedGovernorate,
    currentScreen,
  ];
}
