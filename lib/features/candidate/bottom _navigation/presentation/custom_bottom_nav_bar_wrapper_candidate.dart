import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/service_locator.dart';
import '../../new assess/presentation/controller/assessment_session_cubit.dart';
import '../../profile/presentation/controller/candidate_profile_cubit.dart';
import '../controller/bottom_nav_candidate_cubit.dart';
import 'custom_bottom_nav_bar.dart';


class CustomBottomNavBarWrapperCandidate extends StatelessWidget {


  const CustomBottomNavBarWrapperCandidate({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavCandidateCubit(),
        ),
      ],
      child: const CustomBottomNavBar(),
    );
  }
}
