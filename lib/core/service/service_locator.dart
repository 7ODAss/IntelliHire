import 'package:get_it/get_it.dart';
import 'package:intelli_hire/features/candidate/Notification/domain/Repos/candidate_notfication_repo.dart';
import 'package:intelli_hire/features/candidate/home/data/datasources/home_remote_datasource.dart';
import 'package:intelli_hire/features/candidate/home/domain/repositories/base_home_repository.dart';
import 'package:intelli_hire/features/candidate/home/domain/usecases/get_home_summary_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/get_candidate_cv_usecase.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/usecases/get_candidate_id_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_current_password_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_new_email_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_otp_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_check_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_request_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_verify_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_personal_info_usecase.dart';

// ── Organization / existing ──────────────────────────────────────────────────
import '../../features/Organization/Home/data/data_source/home_remote_data_source.dart';
import '../../features/Organization/Home/data/repos_impl/home_repository_impl.dart';
import '../../features/Organization/Home/domain/repos/home_repo.dart';
import '../../features/Organization/Home/domain/usecases/get_home_data_usecase.dart';
import '../../features/Organization/Home/domain/usecases/get_top_talent_usecase.dart';
import '../../features/Organization/Home/domain/usecases/submit_decision_usecase.dart';
import '../../features/Organization/Home/presentation/controller/home cubit/home_cubit_cubit.dart';
import '../../features/Organization/Home/presentation/controller/review session cubit/cubit/review_session_cubit.dart';
import '../../features/Organization/Profile/data/datasource/user_profile_datasource.dart';
import '../../features/Organization/Profile/data/repo/user_profile_repo.dart';
import '../../features/Organization/Profile/domain/repo/base_user_profile_repo.dart';
import '../../features/Organization/Profile/domain/usecase/user_profile_log_out_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/update_company_info_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/update_company_about_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/get_company_account_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/change_email_password_request_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/change_email_request_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/change_email_confirm_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/request_password_change_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/send_otp_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/confirm_password_change_usecase.dart';
import '../../features/Organization/Profile/domain/usecase/delete_company_account_usecase.dart';
import '../../features/Organization/Profile/presentation/controller/profile_cubit.dart';

// ── Candidate: Assess Manage ─────────────────────────────────────────────────
import '../../features/candidate/assess manage/data/datasources/assess_manage_remote_datasource.dart';
import '../../features/candidate/assess manage/data/repositories/assess_manage_repository_impl.dart';
import '../../features/candidate/assess manage/domain/repositories/base_assess_manage_repository.dart';
import '../../features/candidate/assess manage/domain/usecases/fetch_assessment_history_usecase.dart';
import '../../features/candidate/assess manage/domain/usecases/fetch_performance_report_usecase.dart';
import '../../features/candidate/assess manage/presentation/controller/assess_manage_cubit.dart';

// ── Candidate: New Assessment ────────────────────────────────────────────────
import '../../features/candidate/home/data/repositories/home_repository_impl.dart';
import '../../features/candidate/home/domain/usecases/get_next_week_usecase.dart';
import '../../features/candidate/home/domain/usecases/get_prev_week_usecase.dart';
import '../../features/candidate/home/domain/usecases/reset_week_usecase.dart';
import '../../features/candidate/home/presentation/controller/home_cubit.dart';
import '../../features/candidate/new assess/data/datasources/new_assess_remote_datasource.dart';
import '../../features/candidate/new assess/data/repositories/new_assess_repository_impl.dart';
import '../../features/candidate/new assess/domain/repositories/base_new_assess_repository.dart';
import '../../features/candidate/new assess/domain/usecases/fetch_assessment_questions_usecase.dart';
import '../../features/candidate/new assess/domain/usecases/send_assessment_usecase.dart';
import '../../features/candidate/new assess/domain/usecases/submit_interview_usecase.dart';
import '../../features/candidate/new assess/presentation/controller/assessment_session_cubit.dart';
// ── Candidate: Notifications ─────────────────────────────────────────────────

// ── Candidate: Notifications (الـ Imports الجديدة مع Aliases لمنع التعارض) ───
import '../../features/candidate/Notification/data/DataSources/candidate_notification_remote_data_source.dart';
import '../../features/candidate/Notification/data/repos_impl/candidate_notification_repository_impl.dart';
import '../../features/candidate/Notification/domain/Usecases/get_notifications_usecase.dart' as cand_get;
import '../../features/candidate/Notification/domain/Usecases/delete_notification_usecase.dart' as cand_delete;
import '../../features/candidate/Notification/domain/Usecases/mark_notification_as_read_usecase.dart' as cand_read;
import '../../features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationCubit.dart';

// ── Candidate: Profile ───────────────────────────────────────────────────────
import '../../features/candidate/Notification/data/datasources/notification_remote_datasource.dart';
import '../../features/candidate/Notification/data/repositories/notification_repository_impl.dart';
import '../../features/candidate/profile/data/datasources/candidate_profile_remote_datasource.dart';
import '../../features/candidate/profile/data/repositories/candidate_profile_repository_impl.dart';
import '../../features/candidate/profile/domain/repositories/base_candidate_profile_repository.dart';
import '../../features/candidate/profile/domain/usecases/change_career_details_usecase.dart';
import '../../features/candidate/profile/domain/usecases/change_password_candidate_usecase.dart';
import '../../features/candidate/profile/domain/usecases/delete_account_candidate_usecase.dart';
import '../../features/candidate/profile/domain/usecases/fetch_candidate_profile_usecases.dart';
import '../../features/candidate/profile/domain/usecases/profile_usecases.dart' hide FetchCandidateProfileUseCase;
import '../../features/candidate/profile/domain/usecases/log_out_user_candidate_profile_usecase.dart';
import '../../features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';

///////////////////////////OMAR//////////////////////////////////////////////////

import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/service/notification_hub_service.dart';

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
// ================= Organization Notification Imports =================
import 'package:intelli_hire/features/Organization/Notification/data/DataSources/notification_remote_data_source.dart';
import 'package:intelli_hire/features/Organization/Notification/data/repos_impl/notification_repository_impl.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Repos/notfication_repo.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/get_notifications_usecase.dart';
import 'package:intelli_hire/features/Organization/Notification/domain/Usecases/delete_notification_usecase.dart';
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
  void init() async {
    // ────────────────────────────────────────────────────────────────────────
    // Organization (existing)
    // ────────────────────────────────────────────────────────────────────────
    getIt.registerFactory(() => ProfileCubit(
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt(),
        ));
    getIt.registerLazySingleton<BaseUserProfileDataSource>(
          () => UserProfileDataSource(),
    );
    getIt.registerLazySingleton<BaseUserProfileRepo>(
          () => UserProfileRepo(getIt()),
    );
    getIt.registerLazySingleton(() => LogOutUserProfileUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateCompanyInfoUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateCompanyAboutUseCase(getIt()));
    getIt.registerLazySingleton(() => GetCompanyAccountUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeEmailPasswordRequestUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeEmailRequestUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeEmailConfirmUseCase(getIt()));
    getIt.registerLazySingleton(() => RequestPasswordChangeUseCase(getIt()));
    getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
    getIt.registerLazySingleton(() => ConfirmPasswordChangeUseCase(getIt()));
    getIt.registerLazySingleton(() => DeleteCompanyAccountUseCase(getIt()));

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
    getIt.registerLazySingleton(() => AssessManageCubit(getIt(), getIt()));

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
    getIt.registerLazySingleton(() => FetchAssessmentQuestionsUseCase(getIt()));
    getIt.registerLazySingleton(() => SubmitInterviewUseCase(getIt()));
    getIt.registerLazySingleton(() => SendAssessmentUseCase(getIt()));
    getIt.registerLazySingleton(() => GetCandidateIdUseCase(getIt()));
    getIt.registerLazySingleton(() => GetCandidateCvUseCase(getIt()));
    // Cubit (factory — new instance per assessment session)
    getIt.registerFactory(
      () => AssessmentSessionCubit(getIt(), getIt(), getIt(), getIt(), getIt()),
    );

    // ────────────────────────────────────────────────────────────────────────
    // Candidate: Notifications
    // ────────────────────────────────────────────────────────────────────────

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
    getIt.registerLazySingleton(() => GetNextWeekUseCase(getIt()));
    getIt.registerLazySingleton(() => GetPrevWeekUseCase(getIt()));
    getIt.registerLazySingleton(() => ResetWeekUseCase(getIt()));
    getIt.registerLazySingleton<HomeCubitCandidate>(
      () => HomeCubitCandidate(getIt(), getIt(), getIt(), getIt()),
    );

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
    getIt.registerLazySingleton(() => ChangePersonalInfoUsecase(getIt()));
    getIt.registerLazySingleton(() => ChangePasswordCandidateUseCase(getIt()));
    getIt.registerLazySingleton(() => DeleteAccountCandidateUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeCareerDetailsUseCase(getIt()));
    getIt.registerLazySingleton(
      () => LogOutUserCandidateProfileUseCase(getIt()),
    );
    getIt.registerLazySingleton(
      () => ChangeEmailEnterCurrentPasswordUseCase(getIt()),
    );
    getIt.registerLazySingleton(() => ChangeEmailEnterNewEmailUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangeEmailOtpUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangePasswordOtpRequestUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangePasswordOtpCheckUseCase(getIt()));
    getIt.registerLazySingleton(() => ChangePasswordVerifyUseCase(getIt()));
    getIt.registerFactory<CandidateProfileCubit>(
      () => CandidateProfileCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );

    ////////////////////       OMAR    //////////////////////////////////////////////////
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
    getIt.registerLazySingleton<HomeRemoteDataSourceOrganization>(
          () => HomeRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<HomeRepoOrganization>(() => HomeRepositoryImplOrganization(getIt()));
    getIt.registerLazySingleton<GetDashboardUseCase>(
          () => GetDashboardUseCase(getIt()),
    );
    getIt.registerLazySingleton<HomeOrganizationCubit>(() => HomeOrganizationCubit(getIt()));

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

    getIt.registerFactory<JobManagementCubit>(
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

    // ================= 5. Organization Notifications =================
    getIt.registerLazySingleton<NotificationRemoteDataSourceOrganization>(
          () => NotificationRemoteDataSourceImplOrganization(getIt()),
    );

    getIt.registerLazySingleton<BaseNotificationRepository>(
          () => NotificationRepositoryImpl(remoteDataSource: getIt<NotificationRemoteDataSourceOrganization>()),
    );

    getIt.registerLazySingleton(
          () => GetNotificationsUseCase(getIt<BaseNotificationRepository>()),
    );

    getIt.registerLazySingleton(
          () => MarkAllNotificationsAsReadUseCase(getIt<BaseNotificationRepository>()),
    );

    getIt.registerLazySingleton(
          () => DeleteNotificationUseCase(getIt<BaseNotificationRepository>()),
    );

    getIt.registerFactory(
          () => NotificationCubit(
        getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
        markAllAsReadUseCase: getIt<MarkAllNotificationsAsReadUseCase>(),
        deleteNotificationUseCase: getIt<DeleteNotificationUseCase>(),
        hubService: getIt<NotificationHubService>(),
      ),
    );

    // ================= 6. Candidate Notifications =================

  // ================= 6. Candidate Notifications =================

  getIt.registerLazySingleton(
          () => CandidateNotificationRemoteDataSource(getIt()),
    );

    // 2. Repository (🌟 التعديل هنا: حددنا النوع الصريح اللي الـ UseCase بيطلبه)
    getIt.registerLazySingleton<CandidateNotficationRepo>(
          () => CandidateNotificationRepositoryImpl(remoteDataSource: getIt()),
    );

    // 3. UseCases
    getIt.registerLazySingleton(
          () => cand_get.GetNotificationsUseCase(getIt()),
    );

    getIt.registerLazySingleton(
          () => cand_read.MarkAllNotificationsAsReadUseCase(getIt()),
    );

    getIt.registerLazySingleton(
          () => cand_delete.DeleteNotificationUseCase(getIt()),
    );

    // 4. Cubit
    getIt.registerFactory(
          () => CandidateNotificationcubit(
        getNotificationsUseCase: getIt(),
        markAllAsReadUseCase: getIt(),
        deleteNotificationUseCase: getIt(),
        hubService: getIt(),
      ),
    );
  }
}