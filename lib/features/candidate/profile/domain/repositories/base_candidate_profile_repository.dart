import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/candidate_profile.dart';
import '../entities/logout_candidate.dart';
import '../usecases/change_career_details_usecase.dart';

abstract class BaseCandidateProfileRepository {
  Future<Either<Failure, CandidateProfile>> fetchProfile();
  Future<Either<Failure, CandidateProfile>> updateProfile(CandidateProfile profile);
  Future<Either<Failure, void>> changePassword(String currentPass, String newPass);
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> changeCareerDetails(ChangeCareerDetailsParams parameters);
  Future<Either<Failure, LogoutCandidate>> logOutUserCandidateProfile();
}
