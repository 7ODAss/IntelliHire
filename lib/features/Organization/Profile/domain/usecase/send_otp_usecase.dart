import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class SendOtpUseCase extends BaseUseCase<String, SendOtpParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  SendOtpUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, String>> call(SendOtpParams parameters) {
    return baseUserProfileRepo.sendOtp(
      parameters.email,
      parameters.code,
    );
  }
}

class SendOtpParams extends Equatable {
  final String email;
  final String code;

  const SendOtpParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}
