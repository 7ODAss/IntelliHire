import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';
import '../../../../../core/error/failure.dart';
import '../../data/model/company_account_model.dart';

abstract class BaseUserProfileRepo {
  Future<Either<Failure, Logout>> logOutUserProfile();
  Future<Either<Failure, void>> updateCompanyInfo({
    required String name,
    required String industry,
    required String phoneNumber,
    String? photoPath,
  });
  Future<Either<Failure, void>> updateCompanyAbout({
    required String about,
    required String websiteUrl,
    required String country,
    required String government,
    required String city,
  });
  Future<Either<Failure, CompanyAccountModel>> getCompanyAccount();
  Future<Either<Failure, void>> requestEmailPasswordChange(String password, String currentEmail);
  Future<Either<Failure, void>> requestEmailChange(String currentEmail, String newEmail);
  Future<Either<Failure, void>> confirmEmailChange(String currentEmail, String newEmail, String code);
  Future<Either<Failure, void>> requestPasswordChange(String email);
  Future<Either<Failure, String>> sendOtp(String email, String code);
  Future<Either<Failure, void>> confirmPasswordChange({
    required String email,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Either<Failure, void>> deleteCompanyAccount({
    required String email,
    required String currentPassword,
  });
}