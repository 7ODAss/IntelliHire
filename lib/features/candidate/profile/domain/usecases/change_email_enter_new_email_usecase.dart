import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangeEmailEnterNewEmailUseCase
    extends BaseUseCase<String, ChangeEmailEnterNewEmailParams> {
  final BaseCandidateProfileRepository repo;
  ChangeEmailEnterNewEmailUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(
    ChangeEmailEnterNewEmailParams parameters,
  ) => repo.changeEmailEnterNewEmail(parameters);
}

class ChangeEmailEnterNewEmailParams extends Equatable {
  final String currentEmail;
  final String newEmail;

  const ChangeEmailEnterNewEmailParams({
    required this.newEmail,
    required this.currentEmail,
  });

  @override
  List<Object?> get props => [newEmail, currentEmail];
}
