import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/profile/domain/entities/logout_candidate.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_career_details_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_current_password_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_new_email_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_otp_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_candidate_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_personal_info_usecase.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/repositories/base_candidate_profile_repository.dart';
import '../datasources/candidate_profile_remote_datasource.dart';

class CandidateProfileRepositoryImpl extends BaseCandidateProfileRepository {
  final BaseCandidateProfileDataSource baseCandidateProfileDataSource;
  CandidateProfileRepositoryImpl(this.baseCandidateProfileDataSource);

  @override
  Future<Either<Failure, CandidateProfile>> fetchProfile() async {
    try {
      final result = await baseCandidateProfileDataSource.fetchProfile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePersonalInfoProfile(
    ChangePersonalInfoParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource
          .updatePersonalInfoProfile(
            fullName: parameters.fullName,
            phoneNumber: parameters.phoneNumber,
            image: parameters.image,
          );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LogoutCandidate>> logOutUserCandidateProfile() async {
    try {
      final result = await baseCandidateProfileDataSource
          .logOutUserCandidateProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.serverMessage.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    ChangePasswordParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource.changePassword(
        parameters.currentPassword,
        parameters.newPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final result = await baseCandidateProfileDataSource.deleteAccount();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.serverMessage.message));
    }
  }

  @override
  Future<Either<Failure, void>> changeCareerDetails(
    ChangeCareerDetailsParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource.changeCareerDetails(
        parameters.newCvPath,
        parameters.oldCvData,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changeEmailEnterCurrentPassword(
    ChangeEmailEnterCurrentPasswordParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource
          .changeEmailEnterCurrentPassword(
            currentEmail: parameters.currentEmail,
            currentPassword: parameters.currentPassword,
          );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changeEmailEnterNewEmail(
    ChangeEmailEnterNewEmailParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource
          .changeEmailEnterNewEmail(
            currentEmail: parameters.currentEmail,
            newEmail: parameters.newEmail,
          );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changeEmailOtp(
    ChangeEmailOtpParams parameters,
  ) async {
    try {
      final result = await baseCandidateProfileDataSource.changeEmailOtp(
        otp: parameters.otp,
        newEmail: parameters.newEmail,
        currentEmail: parameters.currentEmail,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
