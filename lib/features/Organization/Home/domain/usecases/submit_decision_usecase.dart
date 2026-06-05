import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';

class SubmitDecisionUseCase {
  final HomeRepoOrganization homeRepo;

  SubmitDecisionUseCase(this.homeRepo);

  Future<Either<String, void>> execute(String sessionId, int status) async {
    return await homeRepo.submitDecision(sessionId, status);
  }
}