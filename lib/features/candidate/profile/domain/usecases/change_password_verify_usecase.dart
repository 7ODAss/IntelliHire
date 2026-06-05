import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangePasswordVerifyUseCase
    extends BaseUseCase<String, ChangePasswordVerifyParams> {
  final BaseCandidateProfileRepository repo;
  ChangePasswordVerifyUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(ChangePasswordVerifyParams parameters) =>
      repo.changePasswordVerify(parameters);
}

class ChangePasswordVerifyParams extends Equatable {
  final String currentEmail;
  final String token;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordVerifyParams({
    required this.currentEmail,
    required this.token,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    currentEmail,
    token,
    currentPassword,
    newPassword,
    confirmPassword,
  ];
}
