import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/assessment.dart';
import '../repositories/base_assess_manage_repository.dart';

class FetchAssessmentHistoryUseCase extends BaseUseCase<List<Assessment>, NoParameters> {
  final BaseAssessManageRepository repo;
  FetchAssessmentHistoryUseCase(this.repo);

  @override
  Future<Either<Failure, List<Assessment>>> call(NoParameters parameters) =>
      repo.fetchAssessmentHistory();
}
