import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangeEmailEnterCurrentPasswordUseCase
    extends BaseUseCase<String, ChangeEmailEnterCurrentPasswordParams> {
  final BaseCandidateProfileRepository repo;
  ChangeEmailEnterCurrentPasswordUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(
    ChangeEmailEnterCurrentPasswordParams parameters,
  ) => repo.changeEmailEnterCurrentPassword(parameters);
}

class ChangeEmailEnterCurrentPasswordParams extends Equatable {
  final String currentEmail;
  final String currentPassword;

  const ChangeEmailEnterCurrentPasswordParams({
    required this.currentPassword,
    required this.currentEmail,
  });

  @override
  List<Object?> get props => [currentPassword, currentEmail];
}
