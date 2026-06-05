import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/screen/login_and_security_screen.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../controller/candidate_profile_cubit.dart';
import '../screen/personal_information_screen.dart';
import 'optionfield.dart';

class AccountOption extends StatelessWidget {
  final CandidateProfileCubit cubit;
  const AccountOption({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: AppTextStyle.accountNamePostScreen),
        Card(
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.person,
                  categoryName: 'Personal Information',
                  options: ['Email , Phone , Photo'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: PersonalInformationScreen(
                            name:
                                cubit.state.candidateProfileModel?.fullName ??
                                '',
                            email:
                                cubit.state.candidateProfileModel?.email ?? '',
                            phone:
                                cubit
                                    .state
                                    .candidateProfileModel
                                    ?.phoneNumber ??
                                '',
                            photo:
                                cubit.state.candidateProfileModel?.photo ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Divider(color: Color(0xFFD6D6D6)),
                ),
                OptionField(
                  icon: Icons.lock_outlined,
                  categoryName: 'Login & Security',
                  options: ['Password , Delete account'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 🌟 FIX: Must wrap with BlocProvider.value so that BlocListener /
                        // BlocSelector inside LoginAndSecurityScreen (and its child screens)
                        // can find CandidateProfileCubit via context lookup.
                        // Without this, those widgets search the widget tree, find nothing,
                        // throw on every rebuild → infinite loop → Signal 3.
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: LoginAndSecurityScreen(cubit: cubit),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
