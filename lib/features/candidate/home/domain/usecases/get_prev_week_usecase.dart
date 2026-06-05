import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import '../entities/weekly_activity_summary.dart';
import '../repositories/base_home_repository.dart';

class GetPrevWeekUseCase extends BaseUseCase<WeeklyActivitySummary,NoParameters>{
  final BaseHomeRepository repo;
  GetPrevWeekUseCase(this.repo);

  @override
  Future<Either<Failure, WeeklyActivitySummary>> call(NoParameters parameters)
  => repo.getPrevWeek();

}