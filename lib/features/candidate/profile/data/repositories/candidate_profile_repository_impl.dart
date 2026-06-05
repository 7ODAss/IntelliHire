import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/profile/domain/entities/logout_candidate.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_career_details_usecase.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/repositories/base_candidate_profile_repository.dart';
import '../datasources/candidate_profile_remote_datasource.dart';
import '../models/candidate_profile_model.dart';

class CandidateProfileRepositoryImpl extends BaseCandidateProfileRepository {
  final BaseCandidateProfileDataSource baseCandidateProfileDataSource;
  CandidateProfileRepositoryImpl(this.baseCandidateProfileDataSource);

  @override
  Future<Either<Failure, CandidateProfile>> fetchProfile() async {
    try {
      final model = await baseCandidateProfileDataSource.fetchProfile();
      return Right(model); // model extends entity, safe upcast
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateProfile>> updateProfile(
    CandidateProfile profile,
  ) async {
    try {
      // Convert entity → model before passing to datasource
      final model = CandidateProfileModel(
        fullName: profile.fullName,
        email: profile.email,
        photo: profile.photo,
      );
      final result = await baseCandidateProfileDataSource.updateProfile(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, LogoutCandidate>> logOutUserCandidateProfile() async{
    try{
      final result = await baseCandidateProfileDataSource.logOutUserCandidateProfile();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.serverMessage.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String currentPass,
      String newPass,
      ) async {
    try {
      await baseCandidateProfileDataSource.changePassword(currentPass, newPass);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async{
    try{
      final result = await baseCandidateProfileDataSource.deleteAccount();
      return Right(result);
    }on ServerException catch(e){
      return Left(ServerFailure(e.serverMessage.message));
    }
  }

  @override
  Future<Either<Failure, void>> changeCareerDetails(ChangeCareerDetailsParams parameters) async{
    try {
      final result = await baseCandidateProfileDataSource.changeCareerDetails(parameters);
      return Right(result);
      } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
