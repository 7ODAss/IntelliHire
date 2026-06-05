import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class UpdateCompanyInfoUseCase extends BaseUseCase<void, UpdateCompanyInfoParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  UpdateCompanyInfoUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(UpdateCompanyInfoParams parameters) {
    return baseUserProfileRepo.updateCompanyInfo(
      name: parameters.name,
      industry: parameters.industry,
      phoneNumber: parameters.phoneNumber,
      photoPath: parameters.photoPath,
    );
  }
}

class UpdateCompanyInfoParams extends Equatable {
  final String name;
  final String industry;
  final String phoneNumber;
  final String? photoPath;

  const UpdateCompanyInfoParams({
    required this.name,
    required this.industry,
    required this.phoneNumber,
    this.photoPath,
  });

  @override
  List<Object?> get props => [name, industry, phoneNumber, photoPath];
}
