import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/entities/performance_report.dart';
import '../../domain/usecases/fetch_assessment_history_usecase.dart';
import '../../domain/usecases/fetch_performance_report_usecase.dart';

part 'assess_manage_state.dart';

class AssessManageCubit extends Cubit<AssessManageState> {
  final FetchAssessmentHistoryUseCase fetchHistoryUseCase;
  final FetchPerformanceReportUseCase fetchReportUseCase;

  AssessManageCubit(this.fetchHistoryUseCase, this.fetchReportUseCase)
      : super(const AssessManageState());

  Future<void> loadAssessmentHistory() async {
    emit(state.copyWith(historyStatus: RequestState.loading));
    final result = await fetchHistoryUseCase(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
        historyStatus: RequestState.error,
        errorMessage: failure.message,
      )),
      (assessments) => emit(state.copyWith(
        historyStatus: RequestState.success,
        assessments: assessments,
      )),
    );
  }

  Future<void> loadPerformanceReport(String assessmentId)
  async {
    emit(state.copyWith(reportStatus: RequestState.loading));
    final result = await fetchReportUseCase(FetchPerformanceReportParams(assessmentId));
    result.fold(
      (failure) => emit(state.copyWith(
        reportStatus: RequestState.error,
        errorMessage: failure.message,
      )),
      (report) => emit(state.copyWith(
        reportStatus: RequestState.success,
        report: report,
      )),
    );
  }

  void toggleExpansion(int questionIndex) {
    final newExpandedQuestions = Set<int>.from(state.expandedQuestions);
    if (newExpandedQuestions.contains(questionIndex)) {
      newExpandedQuestions.remove(questionIndex);
    } else {
      newExpandedQuestions.add(questionIndex);
    }
    emit(state.copyWith(expandedQuestions: newExpandedQuestions));
  }
}
