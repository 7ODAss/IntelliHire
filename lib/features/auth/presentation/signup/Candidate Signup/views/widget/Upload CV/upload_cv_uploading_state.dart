import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';

import '../../../../../../../../core/utils/app_text_style.dart';

class UploadCvUploadingState extends StatelessWidget {
  const UploadCvUploadingState({
    super.key,
    required this.onPressed,
    required this.progress,
    required this.fileName,
  });
  final void Function() onPressed;
  final double progress;
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
                    SizedBox(height: 25),
                    Image(image: AssetImage("assets/image/add_pdf.png")),
                    SizedBox(height: 12),
                    Text("${(progress * 100).toInt()}%"),
                    SizedBox(height: 10),

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
                          value: progress,
                          color: AppColor.primary,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      "Uploading CV",
                      style: AppTextStyle.textstyle14.copyWith(
                        color: Color(0xff0F172A),
                      ),
                    ),
                    Text(fileName, style: AppTextStyle.textstyle12),
                  ],
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
