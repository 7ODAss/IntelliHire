import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/auth/controller/login_cubit.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.5, 0.5, 1.0],
            colors: [
              Colors.white,
              Colors.white,
              Color(0xFF0F172A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/login/logo.svg',
                          height: 60,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome back to IntelliHire',
                      style: AppTextStyle.loginTitleStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Step into the future of hiring',
                      style: AppTextStyle.loginSubTitleStyle,
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                  ),
                ),
                child: BlocProvider(
                  create: (context) => LoginCubit(),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      final cubit = context.read<LoginCubit>();
                      final currentIndex = state.currentIndex;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: List.generate(cubit.pages.length, (index) {
                                  bool isSelected = index == currentIndex;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        cubit.changeIndex(index);
                                        cubit.loginPageController.animateToPage(
                                          index,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFFFFFFF)
                                                : const Color(0xFFF1F1F1),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            cubit.title[index],
                                            style: TextStyle(
                                              color: isSelected
                                                  ? const Color(0xFF0F172A)
                                                  : const Color(0xFFAFAFAF),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          Expanded(
                            child: PageView(
                              controller: cubit.loginPageController,
                              onPageChanged: (index) {
                                cubit.changeIndex(index);
                              },
                              children: cubit.pages,
                            ),
                          ),
                        ],
                      );
                    },
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

//
