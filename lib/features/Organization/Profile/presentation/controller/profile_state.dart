part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final String? selectedCountry;
  final String? selectedGovernorate;
  final String? selectedIndustry;
  final List<CompanyLocation>? locations;
  final RequestState? userProfileLogOutState;
  final String? userProfileLogOutMessage;

  const ProfileState({
    this.selectedCountry,
    this.selectedGovernorate,
    this.selectedIndustry,
    this.locations,
    this.userProfileLogOutState,
    this.userProfileLogOutMessage,
  });

  ProfileState copyWith({
    String? selectedCountry,
    String? selectedGovernorate,
    String? selectedIndustry,
    List<CompanyLocation>? locations,
    RequestState? userProfileLogOutState,
    String? userProfileLogOutMessage,
  }) {
    return ProfileState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      locations: locations ?? this.locations,
      userProfileLogOutState: userProfileLogOutState ?? this.userProfileLogOutState,
      userProfileLogOutMessage: userProfileLogOutMessage ?? this.userProfileLogOutMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedCountry,
    selectedGovernorate,
    selectedIndustry,
    locations,
    userProfileLogOutState,
    userProfileLogOutMessage,
  ];
}
