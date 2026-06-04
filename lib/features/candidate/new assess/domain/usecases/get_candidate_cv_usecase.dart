import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';

class GetCandidateCvUseCase extends BaseUseCase<CvData, GetCandidateCvParams> {
  final BaseNewAssessRepository repository;

  GetCandidateCvUseCase(this.repository);

  @override
  Future<Either<Failure, CvData>> call(GetCandidateCvParams params) async =>
      await repository.getCandidateCv(params.candidateId);
}

class GetCandidateCvParams extends Equatable {
  final String candidateId;

  const GetCandidateCvParams(this.candidateId);

  @override
  List<Object> get props => [candidateId];
}
