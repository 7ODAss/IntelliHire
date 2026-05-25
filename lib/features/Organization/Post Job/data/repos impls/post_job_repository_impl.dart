// Organization/Post Job/data/repos_impl/post_job_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/data/data%20source/post_job_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/entities/location_entity.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/repos/post_job_repo.dart';

class PostJobRepositoryImpl implements PostJobRepo {
  final PostJobRemoteDataSource remoteDataSource;

  PostJobRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, void>> postJob(Map<String, dynamic> jobData) async {
    try {
      await remoteDataSource.postJob(jobData);
      return const Right(null);
    } on DioException catch (e) {
      String errorMessage = 'Failed to post job. Please try again.';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<LocationEntity>>> getCompanyLocations() async {
    try {
      final locations = await remoteDataSource.getCompanyLocations();
      return Right(locations);
    } catch (e) {
      if (e is DioException) {
        return Left(
          e.response?.data['message'] ??
              'An error occurred while fetching locations',
        );
      }
      return Left(e.toString());
    }
  }
}
