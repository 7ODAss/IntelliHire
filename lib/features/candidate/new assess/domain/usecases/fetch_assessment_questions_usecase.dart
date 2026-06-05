import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../entities/question.dart';
import '../repositories/base_new_assess_repository.dart';

class FetchAssessmentQuestionsParams extends Equatable {
  final String title;
  final String track;

  const FetchAssessmentQuestionsParams(this.title,this.track);

  @override
  List<Object?> get props => [title,track];
}

class FetchAssessmentQuestionsUseCase
    extends BaseUseCase<List<Question>, FetchAssessmentQuestionsParams> {
  final BaseNewAssessRepository repo;
  FetchAssessmentQuestionsUseCase(this.repo);

  @override
  Future<Either<Failure, List<Question>>> call(FetchAssessmentQuestionsParams parameters) =>
      repo.fetchAssessmentQuestions(parameters.title,parameters.track);
}
