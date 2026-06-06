import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationCubit.dart';
import '../controller/bottom_nav_candidate_cubit.dart';
import 'custom_bottom_nav_bar.dart';

class CustomBottomNavBarWrapperCandidate extends StatelessWidget {
  const CustomBottomNavBarWrapperCandidate({super.key});

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

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BottomNavCandidateCubit(),
            ),
            // BlocProvider.value — never calls .close() on the cubit.
            // CandidateNotificationcubit is a lazySingleton that owns the
            // single SignalR connection; closing it would kill the hub.
            BlocProvider.value(
              value: getIt<CandidateNotificationcubit>(),
            ),
          ],
          child: const CustomBottomNavBar(),
        );
      },
    );
  }
}