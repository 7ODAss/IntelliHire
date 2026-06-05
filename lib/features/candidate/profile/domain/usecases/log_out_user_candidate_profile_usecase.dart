import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/candidate/profile/domain/entities/logout_candidate.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repositories/base_candidate_profile_repository.dart';


class LogOutUserCandidateProfileUseCase extends BaseUseCase<LogoutCandidate,NoParameters>{
  final BaseCandidateProfileRepository baseCandidateProfileRepository;

  LogOutUserCandidateProfileUseCase(this.baseCandidateProfileRepository);

  @override
  Future<Either<Failure, LogoutCandidate>> call(NoParameters parameters) {
    return baseCandidateProfileRepository.logOutUserCandidateProfile();
  }

}


