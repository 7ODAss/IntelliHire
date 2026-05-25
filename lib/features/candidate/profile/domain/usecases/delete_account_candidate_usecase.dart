import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';

import '../repositories/base_candidate_profile_repository.dart';

class DeleteAccountCandidateUseCase extends BaseUseCase<void,NoParameters>{
  final BaseCandidateProfileRepository repo;
  DeleteAccountCandidateUseCase(this.repo);
  @override
  Future<Either<Failure, void>> call(NoParameters parameters) => repo.deleteAccount();

}