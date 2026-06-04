import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/question.dart';
import '../repositories/base_new_assess_repository.dart';

class FetchAssessmentQuestionsParams extends Equatable {
  final CvData cv;

  const FetchAssessmentQuestionsParams({required this.cv});

  @override
  List<Object?> get props => [cv];
}

class FetchAssessmentQuestionsUseCase
    extends BaseUseCase<List<Question>, FetchAssessmentQuestionsParams> {
  final BaseNewAssessRepository repo;
  FetchAssessmentQuestionsUseCase(this.repo);

  @override
  Future<Either<Failure, List<Question>>> call(
    FetchAssessmentQuestionsParams parameters,
  ) => repo.fetchAssessmentQuestions(parameters.cv);
}
