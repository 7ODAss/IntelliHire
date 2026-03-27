import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';


class LogOutUserProfileUseCase extends BaseUseCase<Logout,NoParameters>{
  final BaseUserProfileRepo baseUserProfileRepo;

  LogOutUserProfileUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, Logout>> call(NoParameters parameters) {
    return baseUserProfileRepo.logOutUserProfile();
  }


}


