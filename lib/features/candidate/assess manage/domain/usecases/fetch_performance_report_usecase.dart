import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/performance_report.dart';
import '../repositories/base_assess_manage_repository.dart';

class FetchPerformanceReportParams extends Equatable {
  final String assessmentId;
  const FetchPerformanceReportParams(this.assessmentId);

  @override
  List<Object?> get props => [assessmentId];
}

class FetchPerformanceReportUseCase
    extends BaseUseCase<PerformanceReport, FetchPerformanceReportParams> {
  final BaseAssessManageRepository repo;
  FetchPerformanceReportUseCase(this.repo);

  @override
  Future<Either<Failure, PerformanceReport>> call(FetchPerformanceReportParams parameters) =>
      repo.fetchPerformanceReport(parameters.assessmentId);
}
