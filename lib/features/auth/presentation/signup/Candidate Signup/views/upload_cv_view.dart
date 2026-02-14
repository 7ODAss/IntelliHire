import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/upload%20cv%20cubit/uploadcv_cubit.dart';
import 'package:intelli_hire/features/auth/controller/upload%20cv%20cubit/uploadcv_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_idle_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploaded_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Upload%20CV/upload_cv_uploading_state.dart';

class UploadCv extends StatelessWidget {
  const UploadCv({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCvCubit(),
      child: BlocBuilder<UploadCvCubit, UploadCvState>(
        builder: (context, state) {
          final cubit = context.read<UploadCvCubit>();

          if (state is UploadCvInitial) {
            return UploadCvIdleState(onPressed: cubit.pickCv);
          }

          if (state is UploadCvUploading) {
            return UploadCvUploadingState(
              progress: state.progress,
              fileName: cubit.selectedFile!.path.split('/').last,
              onPressed: () {},
            );
          }

          if (state is UploadCvSuccess) {
            return UploadCvUploadedState(
              fileName: state.file.path.split('/').last,
              onClear: cubit.clearCv,
              onPressed: onPressed,
            );
          }

          if (state is UploadCvError) {
            return Column(
              children: [
                UploadCvIdleState(onPressed: cubit.pickCv),
                const SizedBox(height: 12),
                Text(state.message, style: const TextStyle(color: Colors.red)),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
