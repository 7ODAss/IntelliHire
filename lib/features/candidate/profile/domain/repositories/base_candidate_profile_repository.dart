import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_current_password_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_new_email_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_otp_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_candidate_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_check_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_request_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_verify_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_personal_info_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/delete_account_candidate_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/candidate_profile.dart';
import '../entities/logout_candidate.dart';
import '../usecases/change_career_details_usecase.dart';

abstract class BaseCandidateProfileRepository {
  Future<Either<Failure, CandidateProfile>> fetchProfile();
  Future<Either<Failure, void>> updatePersonalInfoProfile(
    ChangePersonalInfoParams parameters,
  );
  Future<Either<Failure, void>> changePassword(ChangePasswordParams parameters);
  Future<Either<Failure, String>> deleteAccount(
    DeleteAccountCandidateParams parameters,
  );
  Future<Either<Failure, void>> changeCareerDetails(
    ChangeCareerDetailsParams parameters,
  );
  Future<Either<Failure, LogoutCandidate>> logOutUserCandidateProfile();
  Future<Either<Failure, String>> changeEmailEnterCurrentPassword(
    ChangeEmailEnterCurrentPasswordParams parameters,
  );
  Future<Either<Failure, String>> changeEmailEnterNewEmail(
    ChangeEmailEnterNewEmailParams parameters,
  );
  Future<Either<Failure, String>> changeEmailOtp(
    ChangeEmailOtpParams parameters,
  );

  Future<Either<Failure, String>> changePasswordOtpRequest(
    ChangePasswordOtpRequestParams parameters,
  );
  Future<Either<Failure, (String, String)>> changePasswordOtpCheck(
    ChangePasswordOtpCheckParams parameters,
  );

  Future<Either<Failure, String>> changePasswordVerify(
    ChangePasswordVerifyParams parameters,
  );
}
