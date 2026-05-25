import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/entities/location_entity.dart';

abstract class PostJobRepo {
  Future<Either<String, void>> postJob(Map<String, dynamic> jobData);
  Future<Either<String, List<LocationEntity>>> getCompanyLocations();
}