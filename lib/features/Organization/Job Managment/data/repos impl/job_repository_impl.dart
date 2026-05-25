import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/data%20source/job_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/models/job_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';

class JobRepositoryImpl implements JobRepo {
  final JobRemoteDataSource remoteDataSource;

  JobRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, JobManagementEntity>> getJobsDashboard() async {
    try {
      final response = await remoteDataSource.getJobsDashboard();
      final data = JobManagementModel.fromJson(response);
      return Right(data);
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch jobs data.';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteJob(String jobId) async {
    try {
      await remoteDataSource.deleteJob(jobId);
      return const Right(null);
    } on DioException catch (e) {
      String errorMessage = 'Failed to delete job.';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateJob(
    String jobId,
    Map<String, dynamic> jobData,
  ) async {
    try {
      await remoteDataSource.updateJob(jobId, jobData);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, JobItemEntity>> getJobDetails(String jobId) async {
    try {
      final model = await remoteDataSource.getJobDetails(jobId);
      return Right(model);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
