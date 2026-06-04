import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_career_details_usecase.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../Organization/Profile/presentation/widgets/pop_action_menu.dart';
import '../../../../auth/presentation/login/widget/field_item.dart';
import '../controller/candidate_profile_cubit.dart';
import '../widgets/upload_cv_candidate.dart';

class CareerDetails extends StatefulWidget {
  final String currentRole;
  final double experienceYears;
  const CareerDetails({
    super.key,
    required this.currentRole,
    required this.experienceYears,
  });

  @override
  State<CareerDetails> createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {
  // Career Details
  late TextEditingController currentRoleController;
  late TextEditingController experienceYearsController;
  late GlobalKey<FormState> careerDetailsInfoKey;

  @override
  initState() {
    super.initState();
    currentRoleController = TextEditingController(text: widget.currentRole);
    experienceYearsController = TextEditingController(
      text: widget.experienceYears.toInt().toString(),
    );
    careerDetailsInfoKey = GlobalKey<FormState>();
  }

  @override
  dispose() {
    currentRoleController.dispose();
    experienceYearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) =>
              previous.changeCareerDetailsStatus !=
              current.changeCareerDetailsStatus,
          listener: (context, state) {
            if (state.changeCareerDetailsStatus == RequestState.success) {
              context.showSnackBar(
                type: SnackBarType.success,
                'Career Details Updated Successfully',
              );
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              context.read<CandidateProfileCubit>().clearCv();
              /* currentRoleController.clear();
              experienceYearsController.clear(); */
            }
          },
          builder: (context, state) {
            return BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
              builder: (context, state) {
                final cubit = context.read<CandidateProfileCubit>();
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: careerDetailsInfoKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PopActionMenu(title: 'Career Details'),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FieldItem(
                                controller: currentRoleController,
                                title: 'Current Role',
                                enabled: false,
                                type: TextInputType.text,
                                hintText: 'Software Engineer',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              flex: 2,
                              child: FieldItem(
                                controller: experienceYearsController,
                                title: 'Years Of Experience',
                                enabled: false,
                                type: TextInputType.number,
                                hintText: '5 +',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  if (int.tryParse(value.trim()) == null) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Data extracted from your CV.',
                          style: AppTextStyle.hintTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          'Resume / CV',
                          style: AppTextStyle.fieldTitleStyle,
                        ),
                        const SizedBox(height: 8),
                        UploadCvCandidate(newTitle: "Upload New Cv"),
                        const SizedBox(height: 30),
                        BlocSelector<
                          CandidateProfileCubit,
                          CandidateProfileState,
                          bool
                        >(
                          selector: (state) =>
                              state.changeCareerDetailsStatus ==
                              RequestState.loading,
                          builder: (context, isLoading) {
                            return ButtonAction(
                              title: 'Save Changes',
                              isLoading:
                                  isLoading ||
                                  cubit.state.cvUploadStatus ==
                                      RequestState.loading,
                              onPressed: () {
                                if (careerDetailsInfoKey.currentState!
                                    .validate()) {
                                  final isCvChanged =
                                      cubit.state.selectedCvFile != null;

                                  // 🌟 3. لو مفيش أي تغيير حصل، نوقف التنفيذ ونطلعله تنبيه
                                  if (!isCvChanged) {
                                    context.showSnackBar(
                                      'No changes detected',
                                      type: SnackBarType
                                          .error, // ممكن تخليها Info أو Warning حسب الديزاين بتاعك
                                    );
                                    return; // 🛑 بنوقف الكود هنا عشان ميبعتش الريكويست
                                  }

                                  cubit.changeCareerDetails(
                                    newCvPath:
                                        cubit.state.selectedCvFile?.path ?? '',

                                    oldCvData:
                                        cubit
                                            .state
                                            .candidateProfileModel
                                            ?.cvData ??
                                        '',
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
