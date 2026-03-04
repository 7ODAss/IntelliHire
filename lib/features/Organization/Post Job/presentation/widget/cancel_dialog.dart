import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';

class CancelDialog extends StatelessWidget {
  const CancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Discard Changes?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: AppFont.interBold,
                color: AppColor.darkBlue,
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "Are you sure you want to cancel?\nAny unsaved changes will be lost.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: AppFont.interRegular,
                fontSize: 14,
                color: Color(0XFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColor.primary,
                      padding: const EdgeInsets.only(top: 14, bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<PostJobCubit>().reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 14, bottom: 16),
                      side: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Discard",
                      style: TextStyle(
                        color: AppColor.darkBlue,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFont.interBold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
