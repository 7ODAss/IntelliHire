import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/bottom_nav_candidate_cubit.dart';
import 'custom_bottom_nav_bar.dart';


class CustomBottomNavBarWrapperCandidate extends StatelessWidget {


  const CustomBottomNavBarWrapperCandidate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCandidateCubit(),
      child: const CustomBottomNavBar(),
    );
  }
}
