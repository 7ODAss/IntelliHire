import 'package:get_it/get_it.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/user_profile_log_out_usecase.dart';
import '../../features/Organization/Profile/data/datasource/user_profile_datasource.dart';
import '../../features/Organization/Profile/data/repo/user_profile_repo.dart';
import '../../features/Organization/Profile/domain/repo/base_user_profile_repo.dart';
import '../../features/Organization/Profile/presentation/controller/profile_cubit.dart';


final getIt=GetIt.instance;
class ServiceLocator{
  void init(){
    //cubit
    getIt.registerFactory(()=>ProfileCubit(getIt()));
    //datasource
    getIt.registerLazySingleton<BaseUserProfileDataSource>(()=>UserProfileDataSource());
    //repo
    getIt.registerLazySingleton<BaseUserProfileRepo>(()=>UserProfileRepo(getIt()));
    //usecase
    getIt.registerLazySingleton(()=>LogOutUserProfileUseCase(getIt()));

  }
}