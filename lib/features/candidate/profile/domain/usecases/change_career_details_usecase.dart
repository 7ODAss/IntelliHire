import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';

import '../repositories/base_candidate_profile_repository.dart';

class ChangeCareerDetailsUseCase
    extends BaseUseCase<void, ChangeCareerDetailsParams> {
  final BaseCandidateProfileRepository repo;
  ChangeCareerDetailsUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(ChangeCareerDetailsParams parameters) =>
      repo.changeCareerDetails(parameters);
}

class ChangeCareerDetailsParams extends Equatable {
  final String? newCvPath;
  final String? oldCvData;

  const ChangeCareerDetailsParams({this.newCvPath, this.oldCvData});

  @override
  List<Object?> get props => [newCvPath, oldCvData];
}
