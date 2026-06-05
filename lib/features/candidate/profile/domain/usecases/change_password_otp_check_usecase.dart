import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangePasswordOtpCheckUseCase
    extends BaseUseCase<(String, String), ChangePasswordOtpCheckParams> {
  final BaseCandidateProfileRepository repo;
  ChangePasswordOtpCheckUseCase(this.repo);

  @override
  Future<Either<Failure, (String, String)>> call(
    ChangePasswordOtpCheckParams parameters,
  ) {
    return repo.changePasswordOtpCheck(parameters);
  }
}

class ChangePasswordOtpCheckParams extends Equatable {
  final String currentEmail;
  final String otp;

  const ChangePasswordOtpCheckParams({
    required this.currentEmail,
    required this.otp,
  });

  @override
  List<Object?> get props => [currentEmail, otp];
}
