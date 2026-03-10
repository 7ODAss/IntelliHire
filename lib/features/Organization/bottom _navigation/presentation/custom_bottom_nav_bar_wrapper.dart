import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Profile/controller/profile_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar.dart';

class CustomBottomNavBarWrapper extends StatelessWidget {
  const CustomBottomNavBarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => PostJobCubit()),
        BlocProvider(create: (context) => JobManagementCubit()),
        BlocProvider(create: (context) => ApplicantsCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: const CustomBottomNavBar(),
    );
  }
}
