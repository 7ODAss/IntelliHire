import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/data%20source/applicants_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/models/job_applicants_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/models/report_model.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_applicants_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/report_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/applicants_repo.dart';

class ApplicantsRepositoryImpl implements ApplicantsRepo {
  final ApplicantsRemoteDataSource remoteDataSource;

  ApplicantsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, JobApplicantsListEntity>> getJobApplicants(String jobId) async {
    try {
      final response = await remoteDataSource.getJobApplicants(jobId);
      final data = JobApplicantsListModel.fromJson(response);
      return Right(data);
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch applicants.';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ReportEntity>> getApplicantPreview(String sessionId) async {
    try {
      final response = await remoteDataSource.getApplicantPreview(sessionId);
      final data = ReportModel.fromJson(response);
      return Right(data);
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch applicant preview.';
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}