// features/Organization/Home/domain/repos/home_repo.dart
import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/models/applicant_model.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';

abstract class HomeRepo {
  Future<Either<String, HomeEntity>> getDashboardStats();
  
  Future<Either<String, void>> submitDecision(String sessionId, int status); 
  
  Future<Either<String, List<ApplicantModel>>> getTopTalent(); 
}