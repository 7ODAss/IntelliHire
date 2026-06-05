import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../repo/base_user_profile_repo.dart';

class UpdateCompanyAboutUseCase extends BaseUseCase<void, UpdateCompanyAboutParams> {
  final BaseUserProfileRepo baseUserProfileRepo;

  UpdateCompanyAboutUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, void>> call(UpdateCompanyAboutParams parameters) {
    return baseUserProfileRepo.updateCompanyAbout(
      about: parameters.about,
      websiteUrl: parameters.websiteUrl,
      country: parameters.country,
      government: parameters.government,
      city: parameters.city,
    );
  }
}

class UpdateCompanyAboutParams extends Equatable {
  final String about;
  final String websiteUrl;
  final String country;
  final String government;
  final String city;

  const UpdateCompanyAboutParams({
    required this.about,
    required this.websiteUrl,
    required this.country,
    required this.government,
    required this.city,
  });

  @override
  List<Object?> get props => [about, websiteUrl, country, government, city];
}
