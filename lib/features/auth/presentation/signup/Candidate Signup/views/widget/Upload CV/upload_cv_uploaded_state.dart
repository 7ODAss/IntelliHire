import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';

class UploadCvUploadedState extends StatelessWidget {
  const UploadCvUploadedState({
    super.key,
    required this.onPressed,
    required this.onClear,
    required this.fileName,
  });
  final void Function() onPressed;
  final void Function() onClear;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Color(0xff898989),
              dashPattern: [5, 5],
              strokeWidth: 1,
              radius: Radius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Image(image: AssetImage("assets/image/done_icon.png")),

                    SizedBox(height: 24),
                    Text(
                      "Upload complete",
                      style: AppStyles.textstyle14.copyWith(
                        color: Color(0xff0F172A),
                      ),
                    ),
                    Text(fileName, style: AppStyles.textstyle12),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(
                        FontAwesomeIcons.trashCan,
                        color: Color(0xff0F172A),
                      ),
                      label: Text(
                        "Clear upload",
                        style: AppStyles.textstyle14.copyWith(
                          color: Color(0xff0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          CustomButton(onPressed: onPressed, title: "Upload CV"),
        ],
      ),
    );
  }
}
