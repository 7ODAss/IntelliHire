import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; 
import 'package:intelli_hire/core/error/exception.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/candidate/Notification/data/DataSources/candidate_notification_remote_data_source.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Entities/candidate_notification_entity.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Repos/candidate_notfication_repo.dart';

class CandidateNotificationRepositoryImpl implements CandidateNotficationRepo {
  final CandidateNotificationRemoteDataSource remoteDataSource;

  CandidateNotificationRepositoryImpl({required this.remoteDataSource});

  @override 
  Future<Either<Failure, List<CandidateNotificationEntity>>> getNotifications() async {
    try {
      final result = await remoteDataSource.getNotifications();
      final entities = result.map((model) => CandidateNotificationEntity(
        id: model.id,
        title: model.title,
        description: model.description,
        time: model.time,
        isRead: model.isRead,
      )).toList();
      
      return Right(entities);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
          return Left(ServerFailure("انتهت الجلسة، جاري تسجيل الخروج...")); 
      }
      return Left(ServerFailure("خطأ في الاتصال بالسيرفر."));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع."));
    }
  }

  @override 
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (e) {
       return Left(ServerFailure(e.message ?? 'خطأ في الاتصال'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override 
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      return const Right(null);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.statusMessage));
    } on DioException catch (e) {
       print("🚨 DioException in deleteNotification (Candidate): Status: ${e.response?.statusCode}, Path: ${e.requestOptions.path}, Data: ${e.response?.data}, Message: ${e.message}");
       return Left(ServerFailure(e.message ?? 'خطأ في الاتصال'));
    } catch (e) {
      print("🚨 Unexpected error in deleteNotification (Candidate): $e");
      return Left(ServerFailure(e.toString()));
    }
  }
}