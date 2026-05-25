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
  ];
}
