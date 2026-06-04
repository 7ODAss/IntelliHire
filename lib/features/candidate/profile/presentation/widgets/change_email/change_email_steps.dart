import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/controller/candidate_profile_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/domain/entities/change_email_model.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_email/otp_step_change_email.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';

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
          BlocListener<CandidateProfileCubit, CandidateProfileState>(
            listenWhen: (previous, current) =>
                previous.changeEmailPasswordCheckState !=
                current.changeEmailPasswordCheckState,
            listener: (context, state) {
              if (state.changeEmailPasswordCheckState == RequestState.success) {
                context.showSnackBar(
                  state.changeEmailPasswordCheckMessage,
                  type: SnackBarType.success,
                );
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (state.changeEmailPasswordCheckState ==
                  RequestState.error) {
                context.showSnackBar(
                  state.changeEmailPasswordCheckMessage,
                  type: SnackBarType.error,
                );
              }
            },
          ),

          BlocListener<CandidateProfileCubit, CandidateProfileState>(
            listenWhen: (previous, current) =>
                previous.changeEmailEmailCheckState !=
                current.changeEmailEmailCheckState,
            listener: (context, state) async {
              if (state.changeEmailEmailCheckState == RequestState.success) {
                context.showSnackBar(
                  state.changeEmailEmailCheckMessage,
                  type: SnackBarType.success,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<CandidateProfileCubit>(),
                      child: OtpStepChangeEmail(
                        currentEmail: widget.currentEmail,
                        newEmail: newEmailController.text,
                      ),
                    ),
                  ),
                );
                if (context.mounted) {
                  context
                      .read<CandidateProfileCubit>()
                      .resetEmailChangeStepsStates();
                }
              } else if (state.changeEmailEmailCheckState ==
                  RequestState.error) {
                context.showSnackBar(
                  state.changeEmailEmailCheckMessage,
                  type: SnackBarType.error,
                );
              }
            },
          ),
        ],

        child: BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
          builder: (context, state) {
            final cubit = context.read<CandidateProfileCubit>();
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final emailStep = changeEmailList[index];
                            return Padding(
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
                                  const SizedBox(height: 16),
                                  BlocSelector<
                                    CandidateProfileCubit,
                                    CandidateProfileState,
                                    bool
                                  >(
                                    selector: (state) => state.obsecure,
                                    builder: (context, isObscure) {
                                      return FieldItem(
                                        controller: index == 0
                                            ? currentPasswordController
                                            : newEmailController,
                                        type: TextInputType
                                            .emailAddress, // لاحظ إن الباسورد محتاج visiblePassword مش email
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
                                            .read<CandidateProfileCubit>()
                                            .changeObsecure(),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return index == 0
                                                ? "Password is required"
                                                : "New email is required";
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
