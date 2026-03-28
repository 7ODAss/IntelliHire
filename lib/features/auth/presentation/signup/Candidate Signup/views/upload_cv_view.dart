import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_idle_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploaded_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploading_state.dart';

class UploadCv extends StatelessWidget {
  const UploadCv({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        final cubit = context.read<ProfileSetupCubit>();

        if (state is ProfileUploading) {
          return UploadCvUploadingState(
            progress: state.progress,
            fileName: cubit.selectedCv?.path.split('/').last ?? 'CV',
            onPressed: () {},
          );
        }

        if (state is ProfileError) {
          return Column(
            children: [
              UploadCvIdleState(onPressed: cubit.pickCv),
              const SizedBox(height: 12),
              Text(state.errorMsg, style: const TextStyle(color: Colors.red)),
            ],
          );
        }

        if (cubit.selectedCv != null) {
          return UploadCvUploadedState(
            fileName: cubit.selectedCv!.path.split('/').last,
            onClear: cubit.clearCv,
            onPressed: onPressed,
          );
        }

        return UploadCvIdleState(onPressed: cubit.pickCv);
      },
    );
  }
}
