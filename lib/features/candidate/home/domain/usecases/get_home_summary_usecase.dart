import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repositories/base_home_repository.dart';

class GetHomeSummaryUseCase extends BaseUseCase<HomeSummary, NoParameters> {
  final BaseHomeRepository repo;
  GetHomeSummaryUseCase(this.repo);

  @override
  Future<Either<Failure, HomeSummary>> call(NoParameters parameters) =>
      repo.getHomeSummary();
}
