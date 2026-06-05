import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class ConfirmPasswordChangeUseCase extends BaseUseCase<void, ConfirmPasswordChangeParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  ConfirmPasswordChangeUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(ConfirmPasswordChangeParams parameters) {
    return baseUserProfileRepo.confirmPasswordChange(
      email: parameters.email,
      token: parameters.token,
      currentPassword: parameters.currentPassword,
      newPassword: parameters.newPassword,
      confirmPassword: parameters.confirmPassword,
    );
  }
}

class ConfirmPasswordChangeParams extends Equatable {
  final String email;
  final String token;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ConfirmPasswordChangeParams({
    required this.email,
    required this.token,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        email,
        token,
        currentPassword,
        newPassword,
        confirmPassword,
      ];
}
