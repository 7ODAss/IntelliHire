import 'package:get_it/get_it.dart';

// ── Organization / existing ──────────────────────────────────────────────────
import '../../features/Organization/Profile/data/datasource/user_profile_datasource.dart';
import '../../features/Organization/Profile/data/repo/user_profile_repo.dart';
import '../../features/Organization/Profile/domain/repo/base_user_profile_repo.dart';
import '../../features/Organization/Profile/domain/usecase/user_profile_log_out_usecase.dart';
import '../../features/Organization/Profile/presentation/controller/profile_cubit.dart';

// ── Candidate: Assess Manage ─────────────────────────────────────────────────
import '../../features/candidate/assess manage/data/datasources/assess_manage_remote_datasource.dart';
import '../../features/candidate/assess manage/data/repositories/assess_manage_repository_impl.dart';
import '../../features/candidate/assess manage/domain/repositories/base_assess_manage_repository.dart';
import '../../features/candidate/assess manage/domain/usecases/fetch_assessment_history_usecase.dart';
import '../../features/candidate/assess manage/domain/usecases/fetch_performance_report_usecase.dart';
import '../../features/candidate/assess manage/presentation/controller/assess_manage_cubit.dart';

// ── Candidate: New Assessment ────────────────────────────────────────────────
import '../../features/candidate/new assess/data/datasources/new_assess_remote_datasource.dart';
import '../../features/candidate/new assess/data/repositories/new_assess_repository_impl.dart';
import '../../features/candidate/new assess/domain/repositories/base_new_assess_repository.dart';
import '../../features/candidate/new assess/domain/usecases/fetch_assessment_questions_usecase.dart';
import '../../features/candidate/new assess/domain/usecases/submit_interview_usecase.dart';
import '../../features/candidate/new assess/presentation/controller/assessment_session_cubit.dart';

// ── Candidate: Home ──────────────────────────────────────────────────────────
import '../../features/candidate/home/data/datasources/home_remote_datasource.dart';
import '../../features/candidate/home/data/repositories/home_repository_impl.dart';
import '../../features/candidate/home/domain/repositories/base_home_repository.dart';
import '../../features/candidate/home/domain/usecases/get_home_summary_usecase.dart';
import '../../features/candidate/home/presentation/controller/home_cubit.dart';

// ── Candidate: Notifications ─────────────────────────────────────────────────
import '../../features/candidate/notification/data/datasources/notification_remote_datasource.dart';
import '../../features/candidate/notification/data/repositories/notification_repository_impl.dart';
import '../../features/candidate/notification/domain/repositories/base_notification_repository.dart';
import '../../features/candidate/notification/domain/usecases/fetch_notifications_usecase.dart';
import '../../features/candidate/notification/presentation/controller/notifications_cubit.dart';

// ── Candidate: Profile ───────────────────────────────────────────────────────
import '../../features/candidate/profile/data/datasources/candidate_profile_remote_datasource.dart';
import '../../features/candidate/profile/data/repositories/candidate_profile_repository_impl.dart';
import '../../features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';
import '../../features/candidate/profile/domain/usecases/profile_usecases.dart';
import '../../features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  void init() {
    // ────────────────────────────────────────────────────────────────────────
    // Organization (existing)
    // ────────────────────────────────────────────────────────────────────────
    getIt.registerFactory(() => ProfileCubit(getIt()));
    getIt.registerLazySingleton<BaseUserProfileDataSource>(
      () => UserProfileDataSource(),
    );
    getIt.registerLazySingleton<BaseUserProfileRepo>(
      () => UserProfileRepo(getIt()),
    );
    getIt.registerLazySingleton(() => LogOutUserProfileUseCase(getIt()));

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: Assess Manage
    // ────────────────────────────────────────────────────────────────────────
    // DataSource
    getIt.registerLazySingleton<BaseAssessManageDataSource>(
      () => AssessManageRemoteDataSource(),
    );
    // Repository
    getIt.registerLazySingleton<BaseAssessManageRepository>(
      () => AssessManageRepositoryImpl(getIt()),
    );
    // UseCases
    getIt.registerLazySingleton(() => FetchAssessmentHistoryUseCase(getIt()));
    getIt.registerLazySingleton(() => FetchPerformanceReportUseCase(getIt()));
    // Cubit
    getIt.registerFactory(() => AssessManageCubit(getIt(), getIt()));

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: New Assessment
    // ────────────────────────────────────────────────────────────────────────
    // DataSource
    getIt.registerLazySingleton<BaseNewAssessDataSource>(
      () => NewAssessRemoteDataSource(),
    );
    // Repository
    getIt.registerLazySingleton<BaseNewAssessRepository>(
      () => NewAssessRepositoryImpl(getIt()),
    );
    // UseCases
    getIt.registerLazySingleton(
      () => FetchAssessmentQuestionsUseCase(getIt()),
    );
    getIt.registerLazySingleton(() => SubmitInterviewUseCase(getIt()));
    // Cubit (factory — new instance per assessment session)
    getIt.registerFactory(
      () => AssessmentSessionCubit(getIt(), getIt()),
    );

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: Home
    // ────────────────────────────────────────────────────────────────────────
    getIt.registerLazySingleton<BaseHomeDataSource>(
      () => HomeRemoteDataSource(),
    );
    getIt.registerLazySingleton<BaseHomeRepository>(
      () => HomeRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => GetHomeSummaryUseCase(getIt()));
    getIt.registerFactory(() => HomeCubit(getIt()));

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: Notifications
    // ────────────────────────────────────────────────────────────────────────
    getIt.registerLazySingleton<BaseNotificationDataSource>(
      () => NotificationRemoteDataSource(),
    );
    getIt.registerLazySingleton<BaseNotificationRepository>(
      () => NotificationRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => FetchNotificationsUseCase(getIt()));
    getIt.registerFactory(() => NotificationsCubit(getIt()));

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: Profile
    // ────────────────────────────────────────────────────────────────────────
    getIt.registerLazySingleton<BaseCandidateProfileDataSource>(
      () => CandidateProfileRemoteDataSource(),
    );
    getIt.registerLazySingleton<BaseCandidateProfileRepository>(
      () => CandidateProfileRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton(() => FetchCandidateProfileUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
    getIt.registerFactory(
      () => CandidateProfileCubit(getIt(), getIt()),
    );
  }
}