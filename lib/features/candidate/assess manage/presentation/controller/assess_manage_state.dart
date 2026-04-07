part of 'assess_manage_cubit.dart';

class AssessManageState extends Equatable {
  final RequestState historyStatus;
  final RequestState reportStatus;
  final List<Assessment> assessments;
  final PerformanceReport? report;
  final String errorMessage;

  const AssessManageState({
    this.historyStatus = RequestState.initial,
    this.reportStatus = RequestState.initial,
    this.assessments = const [],
    this.report,
    this.errorMessage = '',
  });

  AssessManageState copyWith({
    RequestState? historyStatus,
    RequestState? reportStatus,
    List<Assessment>? assessments,
    PerformanceReport? report,
    String? errorMessage,
  }) =>
      AssessManageState(
        historyStatus: historyStatus ?? this.historyStatus,
        reportStatus: reportStatus ?? this.reportStatus,
        assessments: assessments ?? this.assessments,
        report: report ?? this.report,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [historyStatus, reportStatus, assessments, report, errorMessage];
}
