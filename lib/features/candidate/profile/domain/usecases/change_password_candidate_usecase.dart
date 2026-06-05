import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repositories/base_candidate_profile_repository.dart';

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordParams(this.currentPassword, this.newPassword);

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class ChangePasswordCandidateUseCase extends BaseUseCase<void, ChangePasswordParams> {
  final BaseCandidateProfileRepository repo;
  ChangePasswordCandidateUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams parameters) =>
      repo.changePassword(parameters.currentPassword, parameters.newPassword);
}
