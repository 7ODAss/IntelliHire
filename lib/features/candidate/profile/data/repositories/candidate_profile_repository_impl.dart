import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/repositories/base_candidate_profile_repository.dart';
import '../datasources/candidate_profile_remote_datasource.dart';
import '../models/candidate_profile_model.dart';

class CandidateProfileRepositoryImpl implements BaseCandidateProfileRepository {
  final BaseCandidateProfileDataSource dataSource;
  CandidateProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, CandidateProfile>> fetchProfile() async {
    try {
      final model = await dataSource.fetchProfile();
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
        id: profile.id,
        name: profile.name,
        email: profile.email,
        track: profile.track,
        avatarInitials: profile.avatarInitials,
      );
      final result = await dataSource.updateProfile(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPass,
    String newPass,
  ) async {
    try {
      await dataSource.changePassword(currentPass, newPass);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
