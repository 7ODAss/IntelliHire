import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/candidate_profile.dart';

abstract class BaseCandidateProfileRepository {
  Future<Either<Failure, CandidateProfile>> fetchProfile();
  Future<Either<Failure, CandidateProfile>> updateProfile(CandidateProfile profile);
  Future<Either<Failure, void>> changePassword(String currentPass, String newPass);
}
