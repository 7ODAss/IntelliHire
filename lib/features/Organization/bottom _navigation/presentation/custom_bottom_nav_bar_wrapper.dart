import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/controller/profile_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar.dart';

class CustomBottomNavBarWrapper extends StatelessWidget {
  const CustomBottomNavBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: StorageService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final String token = snapshot.data ?? "";

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BottomNavCubit()),
            BlocProvider(
              create: (context) => getIt<JobManagementCubit>()..fetchJobs(),
            ),
            BlocProvider(create: (context) => getIt<PostJobCubit>()),
            BlocProvider(create: (context) => getIt<ApplicantsCubit>()),
            BlocProvider(
              create: (context) =>
                  getIt<NotificationCubit>()..initRealTimeNotifications(),
            ),
            BlocProvider(create: (context) => getIt<ProfileCubit>()),
          ],
          child: const CustomBottomNavBar(),
        );
      },
    );
  }
}
