import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/entities/location_entity.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/repos/post_job_repo.dart';

class GetCompanyLocationsUseCase {
  final PostJobRepo postJobRepo;

  GetCompanyLocationsUseCase(this.postJobRepo);

  Future<Either<String, List<LocationEntity>>> execute() async {
    return await postJobRepo.getCompanyLocations();
  }
}