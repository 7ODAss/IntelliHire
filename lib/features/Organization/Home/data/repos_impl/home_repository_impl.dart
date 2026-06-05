import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Home/data/data_source/home_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';

import 'package:intelli_hire/features/Organization/Home/data/models/home_model.dart';

class HomeRepositoryImplOrganization implements HomeRepoOrganization {
  final HomeRemoteDataSourceOrganization remoteDataSource;

  HomeRepositoryImplOrganization(this.remoteDataSource);

  void _cacheUsersFromDashboard(Map<String, dynamic> json) {
    try {
      final List<dynamic>? jobs = json['jobs'] as List<dynamic>?;
      if (jobs != null) {
        for (var job in jobs) {
          final List<dynamic>? users = job['users'] as List<dynamic>?;
          if (users != null) {
            for (var user in users) {
              final String? sessionId = user['sessionId']?.toString();
              if (sessionId != null && sessionId.isNotEmpty) {
                ApplicantModel.sessionCache[sessionId] = {
                  'score': user['score'] ?? user['overallScore'],
                  'photo': user['photo'],
                };
              }
            }
          }
        }
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<Either<String, HomeEntity>> getDashboardStats() async {
    try {
      // 1. جلب بيانات الموبايل لعرضها في الـ UI بشكل سليم بدون تصفير
      final mobileResponse = await remoteDataSource.getDashboardStats();
      final dashboardData = HomeModel.fromJson(mobileResponse);

      // 2. جلب بيانات الويب في الخلفية بشكل صامت لتخزين الـ Score والصورة
      try {
        final webResponse = await remoteDataSource.getWebDashboardStats();
        _cacheUsersFromDashboard(webResponse);
      } catch (e) {
        // ignore background cache failures
      }

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
      final List<ApplicantModel> applicants = response.map((json) {
        ApplicantModel applicant = ApplicantModel.fromJson(json);

        // إثراء البيانات من الكاش إذا كانت متوفرة
        final cache = ApplicantModel.sessionCache[applicant.sessionId];
        if (cache != null) {
          final dynamic rawScore = cache['score'];
          int? score;
          if (rawScore is num) {
            score = rawScore.toInt();
          } else if (rawScore is String) {
            score = double.tryParse(rawScore.replaceAll(RegExp(r'[^\d.]'), '').trim())?.toInt();
          }
          final String? photo = cache['photo']?.toString();

          applicant = applicant.copyWith(
            aiScore: score,
            photo: photo,
          );
        }
        return applicant;
      }).toList();
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