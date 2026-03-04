part of 'applicants_cubit.dart';

class ApplicantsState extends Equatable {
  final List<ApplicantModel> allApplicants;
  final String selectedFilter;

  const ApplicantsState({
    this.allApplicants = const [],
    this.selectedFilter = "All",
  });

  List<ApplicantModel> get filteredApplicants {
    if (selectedFilter == "All") {
      return allApplicants;
    } else if (selectedFilter == "Top Rated") {
      var top = allApplicants.where((a) => a.aiScore >= 80).toList();
      top.sort((a, b) => b.aiScore.compareTo(a.aiScore)); 
      return top;
    } else {
      return allApplicants.where((a) => a.status == selectedFilter).toList();
    }
  }

  ApplicantsState copyWith({
    List<ApplicantModel>? allApplicants,
    String? selectedFilter,
  }) {
    return ApplicantsState(
      allApplicants: allApplicants ?? this.allApplicants,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object> get props => [allApplicants, selectedFilter];
}