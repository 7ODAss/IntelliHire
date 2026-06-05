import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/weekly_activity_summary.dart';
import '../../domain/repositories/base_home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements BaseHomeRepository {
  final BaseHomeDataSource dataSource;
  HomeRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, HomeSummary>> getHomeSummary() async{
    try {
      final result = await dataSource.getHomeSummary();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyActivitySummary>> getNextWeek()  async{
    try {
      final result = await dataSource.getNextWeek();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyActivitySummary>> getPrevWeek()  async{
    try {
      final result = await dataSource.getPrevWeek();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyActivitySummary>> resetWeek()  async{
    try {
      final result = await dataSource.resetWeek();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
