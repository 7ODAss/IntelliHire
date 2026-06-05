import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/enums/snack_bar_type.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../Organization/Profile/presentation/widgets/pop_action_menu.dart';
import '../../../../auth/presentation/login/widget/field_item.dart';
import '../controller/candidate_profile_cubit.dart';
import '../widgets/upload_cv_candidate.dart';

class CareerDetails extends StatelessWidget {
  const CareerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<CandidateProfileCubit, CandidateProfileState>(
          listenWhen: (previous, current) => previous.changeCareerDetailsStatus != current.changeCareerDetailsStatus,
          listener: (context, state) {
            if (state.changeCareerDetailsStatus == RequestState.success) {
              context.showSnackBar(type: SnackBarType.success, 'Career Details Updated Successfully');
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              context.read<CandidateProfileCubit>().clearCv();
              context.read<CandidateProfileCubit>().currentRoleController.clear();
              context.read<CandidateProfileCubit>().experienceYearsController.clear();
            }
          },
          builder: (context, state) {
            return BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
              builder: (context, state) {
                final cubit = context.read<CandidateProfileCubit>();
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: cubit.careerDetailsInfoKey,
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
                                controller: cubit.currentRoleController,
                                title: 'Current Role',
                                type: TextInputType.text,
                                hintText: 'Software Engineer',
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              flex: 2,
                              child: FieldItem(
                                controller: cubit.experienceYearsController,
                                title: 'Years Of Experience',
                                type: TextInputType.number,
                                hintText: '5 +',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 45),
                        Text('Resume / CV',
                            style: AppTextStyle.fieldTitleStyle),
                        const SizedBox(height: 8),
                        UploadCvCandidate(newTitle: "Upload New Cv",)
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


