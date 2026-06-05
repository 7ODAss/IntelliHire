import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../domain/repo/base_user_profile_repo.dart';
import '../datasource/user_profile_datasource.dart';
import '../model/company_account_model.dart';

class UserProfileRepo extends BaseUserProfileRepo {
  final BaseUserProfileDataSource baseUserProfileDataSource;
  
  UserProfileRepo(this.baseUserProfileDataSource);

  Failure _handleException(dynamic e) {
    if (e is DioException) {
      if (e.response != null && e.response!.data != null) {
        try {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            final msg = data['errorMessage'] ?? data['message'] ?? data['error'];
            if (msg != null && msg.toString().isNotEmpty) {
              return ServerFailure(msg.toString());
            }
            final errorModel = ErrorMessageModel.fromJson(data);
            return ServerFailure(errorModel.message);
          } else if (data is String && data.isNotEmpty) {
            if (!data.startsWith('<!DOCTYPE') && !data.startsWith('<html')) {
              return ServerFailure(data);
            }
          }
        } catch (_) {}
      }
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        if (statusCode == 500) {
          return const ServerFailure('Internal server error. Please try again later.');
        }
        if (statusCode == 400) {
          return const ServerFailure('Invalid request. Please verify your input and try again.');
        }
        if (statusCode == 401 || statusCode == 403) {
          return const ServerFailure('Unauthorized access. Please log in again.');
        }
      }
      return const ServerFailure('Network error occurred. Please check your internet connection.');
    }
    if (e is ServerException) {
      return ServerFailure(e.serverMessage.message);
    }
    return ServerFailure(e.toString());
  }

  @override
  Future<Either<Failure, Logout>> logOutUserProfile() async {
    try {
      final result = await baseUserProfileDataSource.logOutUserProfile();
      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCompanyInfo({
    required String name,
    required String industry,
    required String phoneNumber,
    String? photoPath,
  }) async {
    try {
      await baseUserProfileDataSource.updateCompanyInfo(
        name: name,
        industry: industry,
        phoneNumber: phoneNumber,
        photoPath: photoPath,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCompanyAbout({
    required String about,
    required String websiteUrl,
    required String country,
    required String government,
    required String city,
  }) async {
    try {
      await baseUserProfileDataSource.updateCompanyAbout(
        about: about,
        websiteUrl: websiteUrl,
        country: country,
        government: government,
        city: city,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, CompanyAccountModel>> getCompanyAccount() async {
    try {
      final result = await baseUserProfileDataSource.getCompanyAccount();
      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> requestEmailPasswordChange(String password, String currentEmail) async {
    try {
      await baseUserProfileDataSource.requestEmailPasswordChange(password, currentEmail);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> requestEmailChange(String currentEmail, String newEmail) async {
    try {
      await baseUserProfileDataSource.requestEmailChange(currentEmail, newEmail);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> confirmEmailChange(String currentEmail, String newEmail, String code) async {
    try {
      await baseUserProfileDataSource.confirmEmailChange(currentEmail, newEmail, code);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordChange(String email) async {
    try {
      await baseUserProfileDataSource.requestPasswordChange(email);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(String email, String code) async {
    try {
      final token = await baseUserProfileDataSource.sendOtp(email, code);
      return Right(token);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> confirmPasswordChange({
    required String email,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await baseUserProfileDataSource.confirmPasswordChange(
        email: email,
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompanyAccount({
    required String email,
    required String currentPassword,
  }) async {
    try {
      await baseUserProfileDataSource.deleteCompanyAccount(
        email: email,
        currentPassword: currentPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}