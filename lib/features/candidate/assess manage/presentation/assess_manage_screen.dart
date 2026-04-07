import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/controller/assess_manage_cubit.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/screens/assessment_history_screen.dart';

class AssessManageScreen extends StatelessWidget {
  const AssessManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AssessManageCubit>(),
      child: const AssessmentHistoryScreen(),
    );
  }
}
