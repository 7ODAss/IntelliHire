import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/controller/assess_manage_cubit.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/presentation/screens/assessment_history_screen.dart';

class AssessManageScreen extends StatefulWidget {
  const AssessManageScreen({super.key});

  @override
  State<AssessManageScreen> createState() => _AssessManageScreenState();
}

class _AssessManageScreenState extends State<AssessManageScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      getIt<AssessManageCubit>().loadAssessmentHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AssessManageCubit>(),
      child: const AssessmentHistoryScreen(),
    );
  }
}
