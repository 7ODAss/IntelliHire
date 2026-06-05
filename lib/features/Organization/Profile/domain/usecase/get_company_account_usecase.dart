import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../data/model/company_account_model.dart';
import '../repo/base_user_profile_repo.dart';

class GetCompanyAccountUseCase extends BaseUseCase<CompanyAccountModel, NoParameters> {
  final BaseUserProfileRepo baseUserProfileRepo;

  GetCompanyAccountUseCase(this.baseUserProfileRepo);

  @override
  Future<Either<Failure, CompanyAccountModel>> call(NoParameters parameters) {
    return baseUserProfileRepo.getCompanyAccount();
  }
}
