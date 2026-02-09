import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';

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

                    LinearProgressIndicator(value: progress),

                    SizedBox(height: 20),
                    Text(
                      "Uploading CV",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF263238),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      fileName,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
