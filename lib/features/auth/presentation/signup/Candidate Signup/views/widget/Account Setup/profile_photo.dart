import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/profile_photo_picker.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Center(child: ProfilePhotoPicker()),
          const SizedBox(height: 48),
          CustomButton(onPressed: () {}, title: "Complete Registration"),
        ],
      ),
    );
  }
}
