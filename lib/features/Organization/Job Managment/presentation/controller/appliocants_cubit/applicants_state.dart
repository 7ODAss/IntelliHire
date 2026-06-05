import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_applicants_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';

abstract class ApplicantsState {
  // 🔴 ضفنا المتغيرات دي هنا عشان الـ UI يقراها بدون مشاكل
  final String selectedFilter;
  final List<BasicApplicantEntity> filteredApplicants;

  const ApplicantsState({
    this.selectedFilter = "All",
    this.filteredApplicants = const [],
  });
}

class ApplicantsInitial extends ApplicantsState {}

// ================= States for Applicants List =================
class ApplicantsLoading extends ApplicantsState {
  const ApplicantsLoading({super.selectedFilter, super.filteredApplicants});
}

class ApplicantsLoaded extends ApplicantsState {
  final JobApplicantsListEntity data;
  const ApplicantsLoaded({
    required this.data,
    super.selectedFilter,
    super.filteredApplicants,
  });
}

class ApplicantsError extends ApplicantsState {
  final String message;
  const ApplicantsError(
    this.message, {
    super.selectedFilter,
    super.filteredApplicants,
  });
}

// ================= States for Applicant Report Preview =================
class ApplicantPreviewLoading extends ApplicantsState {
  const ApplicantPreviewLoading({
    super.selectedFilter,
    super.filteredApplicants,
  });
}

class ApplicantPreviewLoaded extends ApplicantsState {
  final ReportEntity reportData;
  const ApplicantPreviewLoaded(
    this.reportData, {
    super.selectedFilter,
    super.filteredApplicants,
  });
}

class ApplicantPreviewError extends ApplicantsState {
  final String message;
  const ApplicantPreviewError(
    this.message, {
    super.selectedFilter,
    super.filteredApplicants,
  });
}

// ================= States for Submit Decision =================
class DecisionSubmitting extends ApplicantsState {
  const DecisionSubmitting({super.selectedFilter, super.filteredApplicants});
}

class DecisionSuccess extends ApplicantsState {
  const DecisionSuccess({super.selectedFilter, super.filteredApplicants});
}

class DecisionError extends ApplicantsState {
  final String message;
  const DecisionError(
    this.message, {
    super.selectedFilter,
    super.filteredApplicants,
  });
}
