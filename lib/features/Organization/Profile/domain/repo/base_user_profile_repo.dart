import 'package:dartz/dartz.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';
import '../../../../../core/error/failure.dart';

abstract class BaseUserProfileRepo {
  Future<Either<Failure, Logout>> logOutUserProfile();
}