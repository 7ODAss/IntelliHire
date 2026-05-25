import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';


class GetDashboardUseCase {
  final HomeRepo repository;

  GetDashboardUseCase(this.repository);

  Future<Either<String, HomeEntity>> execute() async {
    return await repository.getDashboardStats();
  }
}