import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangePasswordOtpRequestUseCase
    extends BaseUseCase<String, ChangePasswordOtpRequestParams> {
  final BaseCandidateProfileRepository repo;
  ChangePasswordOtpRequestUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(
    ChangePasswordOtpRequestParams parameters,
  ) => repo.changePasswordOtpRequest(parameters);
}

class ChangePasswordOtpRequestParams extends Equatable {
  final String currentEmail;

  const ChangePasswordOtpRequestParams({required this.currentEmail});

  @override
  List<Object?> get props => [currentEmail];
}
