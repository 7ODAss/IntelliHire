import 'package:dartz/dartz.dart';
import 'package:intelli_hire/core/error/failure.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/entity/logout.dart';
import '../../../../../core/error/exception.dart';
import '../../domain/repo/base_user_profile_repo.dart';
import '../datasource/user_profile_datasource.dart';

class UserProfileRepo extends BaseUserProfileRepo {
  final BaseUserProfileDataSource baseUserProfileDataSource;
   UserProfileRepo(
    this.baseUserProfileDataSource,
  );

  @override
  Future<Either<Failure, Logout>> logOutUserProfile() async{
   try{
     final result = await baseUserProfileDataSource.logOutUserProfile();
     return Right(result);
   }on ServerException catch(e){
     return Left(ServerFailure(e.serverMessage.message));

   }
  }


}