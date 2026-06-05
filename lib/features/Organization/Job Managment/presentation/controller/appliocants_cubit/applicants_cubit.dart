import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_applicants_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_applicant_report_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_job_applicants_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/submit_decision_usecase.dart';
import 'applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  final GetJobApplicantsUseCase getJobApplicantsUseCase;
  final GetApplicantReportUseCase getApplicantPreviewUseCase;
  final SubmitDecisionUseCase submitDecisionUseCase;

  JobApplicantsListEntity? _currentJobData;

  ApplicantsCubit({
    required this.getJobApplicantsUseCase,
    required this.getApplicantPreviewUseCase,
    required this.submitDecisionUseCase,
  }) : super(ApplicantsInitial());

  Future<void> fetchApplicantsForJob(String jobId) async {
    emit(
      ApplicantsLoading(
        selectedFilter: state.selectedFilter,
        filteredApplicants: state.filteredApplicants,
      ),
    );

    final result = await getJobApplicantsUseCase.execute(jobId);

    result.fold((error) => emit(ApplicantsError(error)), (data) {
      _currentJobData = data;
      _applyFilter(state.selectedFilter);
    });
  }

  void changeFilter(String newFilter) {
    _applyFilter(newFilter);
  }

  void _applyFilter(String filter) {
    if (_currentJobData == null) return;

    List<BasicApplicantEntity> filteredList = _currentJobData!.applicants;

    if (filter == "Top Rated") {
      filteredList = _currentJobData!.applicants
          .where((a) => (a.overallScore ?? 0) >= 80)
          .toList();
    } else if (filter != "All") {
      filteredList = _currentJobData!.applicants
          .where((a) => a.status == filter)
          .toList();
    }

    emit(
      ApplicantsLoaded(
        data: _currentJobData!,
        selectedFilter: filter,
        filteredApplicants: filteredList,
      ),
    );
  }

  Future<void> fetchApplicantPreview(String sessionId) async {
    emit(
      ApplicantPreviewLoading(
        selectedFilter: state.selectedFilter,
        filteredApplicants: state.filteredApplicants,
      ),
    );

    final result = await getApplicantPreviewUseCase.execute(sessionId);

    result.fold(
      (error) => emit(ApplicantPreviewError(error)),
      (report) => emit(
        ApplicantPreviewLoaded(
          report,
          selectedFilter: state.selectedFilter,
          filteredApplicants: state.filteredApplicants,
        ),
      ),
    );
  }

  Future<void> submitDecision(String sessionId, int status) async {
    emit(
      DecisionSubmitting(
        selectedFilter: state.selectedFilter,
        filteredApplicants: state.filteredApplicants,
      ),
    );

    final result = await submitDecisionUseCase.execute(sessionId, status);

    result.fold(
      (error) => emit(DecisionError(error)),
      (_) => emit(
        DecisionSuccess(
          selectedFilter: state.selectedFilter,
          filteredApplicants: state.filteredApplicants,
        ),
      ),
    );
  }
}