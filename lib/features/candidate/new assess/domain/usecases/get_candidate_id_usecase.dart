import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/repositories/base_new_assess_repository.dart';

class GetCandidateIdUseCase
    extends BaseUseCase<(String, String), NoParameters> {
  final BaseNewAssessRepository repository;

  GetCandidateIdUseCase(this.repository);

  @override
  Future<Either<Failure, (String, String)>> call(NoParameters params) async =>
      await repository.getCandidateId();
}
