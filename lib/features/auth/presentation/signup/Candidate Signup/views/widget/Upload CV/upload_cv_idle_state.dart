import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';

class UploadCvIdleState extends StatelessWidget {
  const UploadCvIdleState({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onPressed();
            },
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: Color(0xff898989),
                dashPattern: [5, 5],
                strokeWidth: 1,
                radius: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage("assets/image/cv_upload_icon.png"),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          CustomButton(isDisabled: true, title: "Upload CV"),
        ],
      ),
    );
  }
}
