import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
// 👇 تأكد من مسارات الكيوبيت عندك
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/profile_photo_picker.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration Completed Successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          onPressed();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 18),

              const Center(child: ProfilePhotoPicker()),

              const SizedBox(height: 48),

              if (state is ProfileUploading) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LinearProgressIndicator(
                      value: state.progress,
                      color: AppColor.primary,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Uploading Data... ${(state.progress * 100).toInt()}%'),
              ] else ...[
                CustomButton(
                  onPressed: () {
                    final registerCubit =
                        BlocProvider.of<CandidateRegisterCubit>(
                          context,
                          listen: false,
                        );
                    final token = registerCubit.userToken;

                    if (token != null) {
                      context.read<ProfileSetupCubit>().uploadProfileData(
                        token,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Authentication Token is missing!"),
                        ),
                      );
                    }
                  },
                  title: "Complete Registration",
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
