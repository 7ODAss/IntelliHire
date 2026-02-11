part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final bool changeSuffix;
  final bool checkBoxTermsConditions;
  final String? selectedCountry;
  final String? selectedGovernorate;

  const SignUpState({
    this.changeSuffix = true,
    this.checkBoxTermsConditions = false,
    this.selectedCountry,
    this.selectedGovernorate,
  });

  SignUpState copyWith({
    bool? changeSuffix,
    bool? checkBoxTermsConditions,
    String? selectedCountry,
    String? selectedGovernorate,
  }) {
    return SignUpState(
      changeSuffix: changeSuffix ?? this.changeSuffix,
      checkBoxTermsConditions:
          checkBoxTermsConditions ?? this.checkBoxTermsConditions,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
    );
  }

  @override
  List<Object?> get props => [
    changeSuffix,
    checkBoxTermsConditions,
    selectedCountry,
    selectedGovernorate,
  ];
}
