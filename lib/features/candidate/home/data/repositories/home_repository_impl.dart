import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';
import '../../../../../core/error/failure.dart';
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
}
