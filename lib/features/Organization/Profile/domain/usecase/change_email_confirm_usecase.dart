import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class ChangeEmailConfirmUseCase extends BaseUseCase<void, ChangeEmailConfirmParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  ChangeEmailConfirmUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(ChangeEmailConfirmParams parameters) {
    return baseUserProfileRepo.confirmEmailChange(
      parameters.currentEmail,
      parameters.newEmail,
      parameters.code,
    );
  }
}

class ChangeEmailConfirmParams extends Equatable {
  final String currentEmail;
  final String newEmail;
  final String code;

  const ChangeEmailConfirmParams({
    required this.currentEmail,
    required this.newEmail,
    required this.code,
  });

  @override
  List<Object?> get props => [currentEmail, newEmail, code];
}
