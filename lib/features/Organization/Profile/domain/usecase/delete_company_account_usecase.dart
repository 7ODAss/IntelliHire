import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class DeleteCompanyAccountUseCase extends BaseUseCase<void, DeleteCompanyAccountParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  DeleteCompanyAccountUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(DeleteCompanyAccountParams parameters) {
    return baseUserProfileRepo.deleteCompanyAccount(
      email: parameters.email,
      currentPassword: parameters.currentPassword,
    );
  }
}

class DeleteCompanyAccountParams extends Equatable {
  final String email;
  final String currentPassword;

  const DeleteCompanyAccountParams({
    required this.email,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [email, currentPassword];
}
