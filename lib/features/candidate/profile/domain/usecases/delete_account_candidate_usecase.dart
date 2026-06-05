import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';

import '../repositories/base_candidate_profile_repository.dart';

class DeleteAccountCandidateUseCase
    extends BaseUseCase<String, DeleteAccountCandidateParams> {
  final BaseCandidateProfileRepository repo;
  DeleteAccountCandidateUseCase(this.repo);
  @override
  Future<Either<Failure, String>> call(DeleteAccountCandidateParams parameters) =>
      repo.deleteAccount(parameters);
}

class DeleteAccountCandidateParams extends Equatable {
  final String currentEmail;
  final String currentPassword;

  @override
  List<Object?> get props => [currentEmail, currentPassword];
  DeleteAccountCandidateParams({
    required this.currentEmail,
    required this.currentPassword,
  });
}
