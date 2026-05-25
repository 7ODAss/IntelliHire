import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/candidate_profile.dart';
import '../repositories/base_candidate_profile_repository.dart';

class FetchCandidateProfileUseCase extends BaseUseCase<CandidateProfile, NoParameters> {
  final BaseCandidateProfileRepository repo;
  FetchCandidateProfileUseCase(this.repo);

  @override
  Future<Either<Failure, CandidateProfile>> call(NoParameters parameters) =>
      repo.fetchProfile();
}
