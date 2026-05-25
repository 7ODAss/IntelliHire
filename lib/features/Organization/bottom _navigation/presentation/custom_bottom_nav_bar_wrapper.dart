import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar.dart';

class CustomBottomNavBarWrapper extends StatelessWidget {
  const CustomBottomNavBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // 🟢 نقوم بجلب التوكن الذي تم إدخاله في الصفحة السابقة وحفظه في الـ Storage
      future: StorageService.getToken(),
      builder: (context, snapshot) {
        // ننتظر حتى تكتمل عملية القراءة من الذاكرة
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // التوكن المجلوب (إذا لم يوجد نرسل نص فارغ)
        final String token = snapshot.data ?? "";

        return MultiBlocProvider(
          providers: [
            // التحكم في الـ Navigation
            BlocProvider(create: (context) => BottomNavCubit()),

            // إدارة الوظائف (يبدأ بجلب البيانات فوراً)
            BlocProvider(
              create: (context) => getIt<JobManagementCubit>()..fetchJobs(),
            ),

            // إدارة إضافة الوظائف
            BlocProvider(create: (context) => getIt<PostJobCubit>()),

            // إدارة المتقدمين
            BlocProvider(create: (context) => getIt<ApplicantsCubit>()),

            // 🟢 الإشعارات: يتم تمرير التوكن المجلوب من الـ StorageService هنا
            BlocProvider(
              create: (context) => getIt<NotificationCubit>()..initRealTimeNotifications(token),
            ),
          ],
          child: const CustomBottomNavBar(),
        );
      },
    );
  }
}