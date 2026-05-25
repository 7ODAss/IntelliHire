import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_information_company.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_link_company.dart';
import 'package:intelli_hire/features/auth/presentation/signup/company/process/sign_up_location_company.dart';

import '../../../../../core/enums/request.dart';
import '../../../controller/sign_up_cubit/sign_up_cubit.dart';
import 'widget/company_sign_up_header.dart';

class SignUpProcess extends StatelessWidget {
  const SignUpProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final cubit = context.read<SignUpCubit>();
        final currentScreen = state.currentScreen;
        final bool isLoading = state.signUpState == RequestState.loading;
        final List<String> titles = [
          'Company Info',
          'Location',
          'Website & Company Logo',
        ];
        final List<String> subtitles = [
          'Let\'s get to know your organization better',
          'Where is your company headquarters located?',
          'Help candidates know more about you',
        ];
        return PopScope(
          canPop: !isLoading,
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Scaffold(
              body: Column(
                children: [
                  CompanySignupHeader(
                    screenNumber: currentScreen,
                    title: titles[currentScreen],
                    subtitle: subtitles[currentScreen],
                    onPressed: () {
                      if (currentScreen > 0) {
                        cubit.previousStep();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: currentScreen,
                      children: [
                        SignUpInformationCompany(),
                        SignUpLocationCompany(),
                        SignUpLinkCompany(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
