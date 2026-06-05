import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class RequestPasswordChangeUseCase extends BaseUseCase<void, String> {
  final BaseUserProfileRepo baseUserProfileRepo;

  RequestPasswordChangeUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(String email) {
    return baseUserProfileRepo.requestPasswordChange(email);
  }
}
