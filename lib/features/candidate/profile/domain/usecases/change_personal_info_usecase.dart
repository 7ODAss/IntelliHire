import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';

class ChangePersonalInfoUsecase
    extends BaseUseCase<void, ChangePersonalInfoParams> {
  final BaseCandidateProfileRepository repository;

  ChangePersonalInfoUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePersonalInfoParams params) async {
    return await repository.updatePersonalInfoProfile(params);
  }
}

class ChangePersonalInfoParams extends Equatable {
  final String fullName;
  final String phoneNumber;
  final File? image;

  const ChangePersonalInfoParams({
    required this.fullName,
    required this.phoneNumber,
    this.image,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, image];
}
