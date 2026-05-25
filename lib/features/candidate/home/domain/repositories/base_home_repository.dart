import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/home_summary.dart';
import '../entities/weekly_activity_summary.dart';

abstract class BaseHomeRepository {
  Future<Either<Failure, HomeSummary>> getHomeSummary();
  Future<Either<Failure, WeeklyActivitySummary>> getNextWeek();
  Future<Either<Failure, WeeklyActivitySummary>> getPrevWeek();
  Future<Either<Failure, WeeklyActivitySummary>> resetWeek();
}
