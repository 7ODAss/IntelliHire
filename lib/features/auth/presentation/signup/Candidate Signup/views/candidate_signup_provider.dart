import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/candidate_signup_view.dart';

class CandidateSignupProvider extends StatelessWidget {
  const CandidateSignupProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CandidateRegisterCubit(ApiService()),
      child: const CandidateSignUpView(), 
    );
  }
}