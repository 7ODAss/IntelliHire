import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class ChangeEmailRequestUseCase extends BaseUseCase<void, ChangeEmailRequestParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  ChangeEmailRequestUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(ChangeEmailRequestParams parameters) {
    return baseUserProfileRepo.requestEmailChange(
      parameters.currentEmail,
      parameters.newEmail,
    );
  }
}

class ChangeEmailRequestParams extends Equatable {
  final String currentEmail;
  final String newEmail;

  const ChangeEmailRequestParams({
    required this.currentEmail,
    required this.newEmail,
  });

  @override
  List<Object?> get props => [currentEmail, newEmail];
}
