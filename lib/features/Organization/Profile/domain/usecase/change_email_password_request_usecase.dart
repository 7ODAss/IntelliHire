import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class ChangeEmailPasswordRequestUseCase extends BaseUseCase<void, ChangeEmailPasswordRequestParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  ChangeEmailPasswordRequestUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(ChangeEmailPasswordRequestParams parameters) {
    return baseUserProfileRepo.requestEmailPasswordChange(
      parameters.password,
      parameters.currentEmail,
    );
  }
}

class ChangeEmailPasswordRequestParams extends Equatable {
  final String password;
  final String currentEmail;

  const ChangeEmailPasswordRequestParams({
    required this.password,
    required this.currentEmail,
  });

  @override
  List<Object?> get props => [password, currentEmail];
}
