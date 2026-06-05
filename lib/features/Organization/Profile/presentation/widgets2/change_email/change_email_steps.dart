import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../controller/profile_cubit.dart';
import '../pop_action_menu.dart';
import 'otp_step_change_email.dart';

class ChangeEmailStep {
  final String title;
  final String subTitle;
  final String desc;
  final String fieldTitle;
  final String hintText;
  final IconData icon;

  const ChangeEmailStep({
    required this.title,
    required this.subTitle,
    required this.desc,
    required this.fieldTitle,
    required this.hintText,
    required this.icon,
  });
}

final List<ChangeEmailStep> changeEmailList = [
  const ChangeEmailStep(
    title: 'Confirm Password',
    subTitle: 'Please enter your current password',
    desc: 'To secure your account, confirm your identity before changing your email.',
    fieldTitle: 'Current Password',
    hintText: 'Enter current password',
    icon: Icons.lock_outlined,
  ),
  const ChangeEmailStep(
    title: 'New Email',
    subTitle: 'Please enter your new email address',
    desc: 'We will send a 6-digit confirmation code to your new email.',
    fieldTitle: 'New Email',
    hintText: 'Enter new email address',
    icon: Icons.email_outlined,
  ),
];

class ChangeEmailSteps extends StatefulWidget {
  final String currentEmail;
  const ChangeEmailSteps({super.key, required this.currentEmail});

  @override
  State<ChangeEmailSteps> createState() => _ChangeEmailStepsState();
}

class _ChangeEmailStepsState extends State<ChangeEmailSteps> {
  late PageController pageController;
  late TextEditingController currentPasswordController;
  late TextEditingController newEmailController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    currentPasswordController = TextEditingController();
    newEmailController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPasswordController.dispose();
    newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listenWhen: (previous, current) =>
                previous.changeEmailPasswordCheckState !=
                current.changeEmailPasswordCheckState,
            listener: (context, state) {
              if (state.changeEmailPasswordCheckState == RequestState.success) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),

          BlocListener<ProfileCubit, ProfileState>(
            listenWhen: (previous, current) =>
                previous.changeEmailEmailCheckState !=
                current.changeEmailEmailCheckState,
            listener: (context, state) async {
              if (state.changeEmailEmailCheckState == RequestState.success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileCubit>(),
                      child: OtpStepChangeEmail(
                        currentEmail: widget.currentEmail,
                        newEmail: newEmailController.text,
                      ),
                    ),
                  ),
                );
                if (context.mounted) {
                  context
                      .read<ProfileCubit>()
                      .resetEmailChangeStepsStates();
                }
              }
            },
          ),
        ],

        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            return Form(
              key: formKey,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      PopActionMenu(
                        title: 'Change Email',
                        fun: Navigator.of(context).pop,
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: changeEmailList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final emailStep = changeEmailList[index];
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emailStep.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      emailStep.subTitle,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      emailStep.desc,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (index == 0 &&
                                        state.changeEmailPasswordCheckState == RequestState.error &&
                                        state.changeEmailPasswordCheckMessage != null &&
                                        state.changeEmailPasswordCheckMessage!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        state.changeEmailPasswordCheckMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                    if (index == 1 &&
                                        state.changeEmailEmailCheckState == RequestState.error &&
                                        state.changeEmailEmailCheckMessage != null &&
                                        state.changeEmailEmailCheckMessage!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        state.changeEmailEmailCheckMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    BlocSelector<
                                      ProfileCubit,
                                      ProfileState,
                                      bool
                                    >(
                                      selector: (state) => state.obsecure,
                                      builder: (context, isObscure) {
                                        return FieldItem(
                                          controller: index == 0
                                              ? currentPasswordController
                                              : newEmailController,
                                          type: index == 0
                                              ? TextInputType.visiblePassword
                                              : TextInputType.emailAddress,
                                          title: emailStep.fieldTitle,
                                          hintText: emailStep.hintText,
                                          obscureText: index == 0
                                              ? isObscure
                                              : false,
                                          prefixIcon: emailStep.icon,
                                          suffixIcon: index == 0
                                              ? (isObscure
                                                    ? Icons.visibility_off
                                                    : Icons.visibility)
                                              : null,
                                          onSuffixPressed: () => context
                                              .read<ProfileCubit>()
                                              .changeObsecure(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return index == 0
                                                  ? "Password is required"
                                                  : "New email is required";
                                            }
                                            if (index == 1 && !value.contains('@')) {
                                              return "Please enter a valid email address";
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 50),
                                    ButtonAction(
                                      title: 'Continue',
                                      isLoading: index == 0
                                          ? state.changeEmailPasswordCheckState ==
                                                RequestState.loading
                                          : state.changeEmailEmailCheckState ==
                                                RequestState.loading,
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          if (index == 0) {
                                            cubit.confirmCurrentPassword(
                                              currentEmail: widget.currentEmail,
                                              currentPassword:
                                                  currentPasswordController.text,
                                            );
                                          } else {
                                            cubit.sendCode(
                                              currentEmail: widget.currentEmail,
                                              newEmail: newEmailController.text,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
