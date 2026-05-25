import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';

import '../repositories/base_candidate_profile_repository.dart';

class ChangeCareerDetailsUseCase extends BaseUseCase<void,ChangeCareerDetailsParams>{
  final BaseCandidateProfileRepository repo;
  ChangeCareerDetailsUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(ChangeCareerDetailsParams parameters) => repo.changeCareerDetails(parameters);

}

class ChangeCareerDetailsParams extends Equatable{
  final String currentRole;
  final int experienceYears;
  final String cv;

  const ChangeCareerDetailsParams({
    required this.currentRole,
    required this.experienceYears,
    required this.cv,
  });

  @override
  List<Object?> get props => [currentRole, experienceYears, cv];
}