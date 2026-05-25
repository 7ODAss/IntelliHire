// Organization/Post Job/domain/usecases/post_job_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/repos/post_job_repo.dart';

class PostJobUseCase {
  final PostJobRepo repository;

  PostJobUseCase(this.repository);

  Future<Either<String, void>> execute(Map<String, dynamic> jobData) async {
    return await repository.postJob(jobData);
  }
}