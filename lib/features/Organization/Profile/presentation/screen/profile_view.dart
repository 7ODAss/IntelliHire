import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import '../../../../auth/presentation/login/login_screen.dart';
import '../../../bottom _navigation/controller/bottom_nav_cubit.dart';
import '../controller/profile_cubit.dart';
import '../widgets/accountoption.dart';
import '../widgets/companyoption.dart';
import '../widgets/pop_action_menu.dart';

class ProfileView extends StatelessWidget {
  final String name = 'Tech Corp Inc.';
  final String email = 'techcorp@business.com';

  const ProfileView({super.key});

  String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.length >= 2) {
      initials += '${names[0][0]}${names[1][0]}';
    }
    else if (names.length == 1) {
      initials += names[0][0];
    }
    else {
      initials = 'TT';
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PopActionMenu(
                title: 'Account Profile',
                fun: context
                    .read<BottomNavCubit>()
                    .goBackToPrevious,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColor.iconProfileColor,
                          border: Border.all(
                            color: AppColor.iconProfileBorderColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(150)),
                        ),
                        child: Center(
                          child: Text(
                            getInitials(name),
                            style: AppTextStyle.iconNamePostScreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        name,
                        style: AppTextStyle.accountNamePostScreen,
                      ),
                      Text(
                        email,
                        style: AppTextStyle.accountSubNamePostScreen,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 32),
              AccountOption(),

              const SizedBox(height: 24),
              CompanyOption(),

              const SizedBox(height: 48),
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    cubit.logout();

                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFFFF1F1),
                            radius: 25,
                            child: Icon(
                              Icons.logout,
                              color: Color(0xFFEF4444),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Logout',
                                style: AppTextStyle.accountNamePostScreen
                                    .copyWith(
                                  color: Color(0xFFEF4444),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
