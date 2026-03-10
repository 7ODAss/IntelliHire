part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final String? selectedCountry;
  final String? selectedGovernorate;
  final String? selectedIndustry;
  final List<CompanyLocationModel>? locations;

  const ProfileState({
    this.selectedCountry,
    this.selectedGovernorate,
    this.selectedIndustry,
    this.locations,
});

  ProfileState copyWith({
    String? selectedCountry,
    String? selectedGovernorate,
    String? selectedIndustry,
    List<CompanyLocationModel>? locations
  }) {
    return ProfileState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      locations: locations ?? this.locations,
    );
  }
  @override
  List<Object?> get props => [selectedCountry,selectedGovernorate,selectedIndustry,locations];
}
