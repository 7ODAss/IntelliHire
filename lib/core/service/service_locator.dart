import 'package:get_it/get_it.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';

// ================= Home Imports =================
import 'package:intelli_hire/features/Organization/Home/data/data_source/home_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Home/data/repos_impl/home_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Home/domain/repos/home_repo.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_home_data_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/submit_decision_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_top_talent_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/review%20session%20cubit/cubit/review_session_cubit.dart';

// ================= Job Management & Applicants Imports =================
import 'package:intelli_hire/features/Organization/Job%20Managment/data/data%20source/applicants_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/data%20source/job_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/repos%20impl/applicants_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/data/repos%20impl/job_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/applicants_repo.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/repos/job_repo.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/delete_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_job_applicants_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_jobs_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_applicant_report_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/update_job_usecase.dart'; 
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_job_details_usecase.dart'; 
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';

// ================= Notification Imports =================
import 'package:intelli_hire/features/Organization/Notification/data/DataSources/notification_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Notification/data/repos_impl/notification_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/get_notifications_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/mark_notification_as_read_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_cubit.dart';

// ================= Post Job Imports =================
import 'package:intelli_hire/features/Organization/Post%20Job/data/data%20source/post_job_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/data/repos%20impls/post_job_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/repos/post_job_repo.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/post_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/get_company_locations_usecase.dart'; 
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/auth/controller/external%20login/external_login_cubit.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void init() {
    // 0. Core Services
    if (!getIt.isRegistered<ApiService>()) {
      getIt.registerLazySingleton<ApiService>(() => ApiService());
    }

    if (!getIt.isRegistered<NotificationHubService>()) {
      getIt.registerLazySingleton<NotificationHubService>(
        () => NotificationHubService(),
      );
    }

    getIt.registerFactory<ExternalLoginCubit>(() => ExternalLoginCubit());

    // ================= 1. Home Dashboard =================
    getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<HomeRepo>(() => HomeRepositoryImpl(getIt()));
    getIt.registerLazySingleton<GetDashboardUseCase>(
      () => GetDashboardUseCase(getIt()),
    );
    
    // 🟢 تم التغيير من registerFactory إلى registerLazySingleton لضمان تحديث الواجهة من أي مكان
    getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt()));

    // ================= 2. Review Session & Decisions =================
    getIt.registerLazySingleton(() => SubmitDecisionUseCase(getIt()));
    getIt.registerLazySingleton(() => GetTopTalentUseCase(getIt()));
    getIt.registerFactory(() => ReviewSessionCubit(getIt(), getIt()));

    // ================= 3. Job Management & Applicants =================
    getIt.registerLazySingleton<JobRemoteDataSource>(
      () => JobRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<ApplicantsRemoteDataSource>(
      () => ApplicantsRemoteDataSourceImpl(getIt()),
    );

    getIt.registerLazySingleton<JobRepo>(() => JobRepositoryImpl(getIt()));
    getIt.registerLazySingleton<ApplicantsRepo>(
      () => ApplicantsRepositoryImpl(getIt()),
    );

    getIt.registerLazySingleton(() => GetJobsUseCase(getIt()));
    getIt.registerLazySingleton(() => GetJobApplicantsUseCase(getIt()));
    getIt.registerLazySingleton(() => DeleteJobUseCase(getIt()));
    getIt.registerLazySingleton(() => GetApplicantReportUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateJobUseCase(getIt<JobRepo>())); 
    getIt.registerLazySingleton(() => GetJobDetailsUseCase(getIt<JobRepo>())); 

    // 🟢 يفضل أيضاً جعل JobManagementCubit سينجلتون لو كنت عايز التغييرات تسمع فيه من شاشات تانية
    getIt.registerLazySingleton<JobManagementCubit>(
      () => JobManagementCubit(
        getIt<GetJobsUseCase>(),
        getIt<DeleteJobUseCase>(),
      ),
    );

    getIt.registerFactory(
      () => ApplicantsCubit(
        getJobApplicantsUseCase: getIt(),
        getApplicantPreviewUseCase: getIt(),
        submitDecisionUseCase: getIt(),
      ),
    );

    // ================= 4. Post Job =================
    getIt.registerLazySingleton<PostJobRemoteDataSource>(
      () => PostJobRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<PostJobRepo>(
      () => PostJobRepositoryImpl(getIt()),
    );
    
    getIt.registerLazySingleton(() => PostJobUseCase(getIt()));
    getIt.registerLazySingleton(() => GetCompanyLocationsUseCase(getIt())); 
    
    getIt.registerFactory(() => PostJobCubit(
          postJobUseCase: getIt<PostJobUseCase>(),
          updateJobUseCase: getIt<UpdateJobUseCase>(),
          getJobDetailsUseCase: getIt<GetJobDetailsUseCase>(),
          getCompanyLocationsUseCase: getIt<GetCompanyLocationsUseCase>(), 
        ));

    // ================= 5. Notifications =================
    getIt.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(getIt()),
    );

    getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
    );

    getIt.registerLazySingleton(
      () => GetNotificationsUseCase(getIt<NotificationRepository>()),
    );
    getIt.registerLazySingleton(
      () => MarkNotificationAsReadUseCase(getIt<NotificationRepository>()),
    );

    getIt.registerFactory(
      () => NotificationCubit(
        getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
        markAsReadUseCase: getIt<MarkNotificationAsReadUseCase>(),
        hubService: getIt<NotificationHubService>(),
      ),
    );
  }
}