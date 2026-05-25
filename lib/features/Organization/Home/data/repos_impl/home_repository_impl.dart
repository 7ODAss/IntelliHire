import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Home/data/data_source/home_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';

import '../models/home_model.dart';

class HomeRepositoryImplOrganization implements HomeRepoOrganization {
  final HomeRemoteDataSourceOrganization remoteDataSource;

  HomeRepositoryImplOrganization(this.remoteDataSource);

  @override
  Future<Either<String, HomeEntity>> getDashboardStats() async {
    try {
      final response = await remoteDataSource.getDashboardStats();
      final dashboardData = HomeModel.fromJson(response);
      return Right(dashboardData);
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch dashboard data. Please try again.';

      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.data is String &&
          e.response!.data.toString().isNotEmpty) {
        errorMessage = e.response!.data.toString();
      }

      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

 @override
  Future<Either<String, void>> submitDecision(
    String sessionId,
    int status, 
  ) async {
    try {
      await remoteDataSource.submitDecision(sessionId, status); 
      return const Right(null);
    } on DioException catch (e) {
      String errorMessage = 'Failed to submit decision. Please try again.';

      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.data is String &&
          e.response!.data.toString().isNotEmpty) {
        errorMessage = e.response!.data.toString();
      }

      return Left(errorMessage);
    } catch (e) {
      return Left('Please check your internet connection and try again.');
    }
  }

  @override
  Future<Either<String, List<ApplicantModel>>> getTopTalent() async {
    try {
      final response = await remoteDataSource.getTopTalent();
      final List<ApplicantModel> applicants = response
          .map((json) => ApplicantModel.fromJson(json))
          .toList();
      return Right(applicants);
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch top talent. Please try again.';

      if (e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.data is String &&
          e.response!.data.toString().isNotEmpty) {
        errorMessage = e.response!.data.toString();
      }

      return Left(errorMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}