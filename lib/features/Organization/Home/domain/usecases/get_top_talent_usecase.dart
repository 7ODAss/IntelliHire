import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';

class GetTopTalentUseCase {
  final HomeRepoOrganization repository;

  GetTopTalentUseCase(this.repository);

  Future<Either<String, List<ApplicantModel>>> execute() async {
    return await repository.getTopTalent();
  }
}