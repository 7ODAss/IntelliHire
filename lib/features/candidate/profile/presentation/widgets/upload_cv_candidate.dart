import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/upload%20cv%20cubit/uploadcv_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_idle_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploaded_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploading_state.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/service/service_locator.dart';
import '../../domain/usecases/change_career_details_usecase.dart';
import '../controller/candidate_profile_cubit.dart';

class UploadCvCandidate extends StatelessWidget {
  final String? newTitle;
  const UploadCvCandidate({super.key, this.newTitle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidateProfileCubit, CandidateProfileState>(
      buildWhen: (previous, current) =>
          previous.cvUploadStatus != current.cvUploadStatus ||
          previous.cvUploadProgress != current.cvUploadProgress ||
          previous.selectedCvFile != current.selectedCvFile,
      builder: (context, state) {
        final cubit = context.read<CandidateProfileCubit>();

        if (state.cvUploadStatus == RequestState.initial) {
          return UploadCvIdleState(onPressed: cubit.pickCv);
        }

        if (state.cvUploadStatus == RequestState.loading) {
          final fileName = state.selectedCvFile?.path.split('/').last ?? 'Uploading...';
          return UploadCvUploadingState(
            progress: state.cvUploadProgress,
            fileName: fileName,
            onPressed: () {},
          );
        }

        if (state.cvUploadStatus == RequestState.success &&
            state.selectedCvFile != null) {
          final fileName = state.selectedCvFile!.path.split('/').last;
          return UploadCvUploadedState(
            fileName: fileName,
            onClear: cubit.clearCv,
            onPressed: () {
              cubit.changeCareerDetails(ChangeCareerDetailsParams(
                currentRole: cubit.currentRoleController.text,
                experienceYears: int.tryParse(cubit.experienceYearsController.text) ?? 0,
                cv: state.selectedCvFile!.path,
              ));
            },
          );
        }

        if (state.cvUploadStatus == RequestState.error) {
          return Column(
            children: [
              UploadCvIdleState(onPressed: cubit.pickCv),
              const SizedBox(height: 12),
              Text(
                state.cvErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          );
        }
        return UploadCvIdleState(onPressed: cubit.pickCv);
      },
    );
  }
}
