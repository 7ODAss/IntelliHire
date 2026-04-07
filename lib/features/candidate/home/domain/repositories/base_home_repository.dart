import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/home_summary.dart';

abstract class BaseHomeRepository {
  Future<Either<Failure, HomeSummary>> getHomeSummary();
}
