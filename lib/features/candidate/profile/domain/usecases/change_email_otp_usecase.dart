import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangeEmailOtpUseCase extends BaseUseCase<String, ChangeEmailOtpParams> {
  final BaseCandidateProfileRepository repo;
  ChangeEmailOtpUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(ChangeEmailOtpParams parameters) =>
      repo.changeEmailOtp(parameters);
}

class ChangeEmailOtpParams extends Equatable {
  final String currentEmail;
  final String newEmail;
  final String otp;
  const ChangeEmailOtpParams({
    required this.otp,
    required this.newEmail,
    required this.currentEmail,
  });

  @override
  List<Object?> get props => [otp, newEmail, currentEmail];
}
