import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_styles.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Image.asset(
              "assets/image/google_icon.png",
              width: 20,
              height: 20,
            ),

            label: const Text("Google", style: AppStyles.textstyle14),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Image.asset(
              "assets/image/linkedin_icon.png",
              width: 20,
              height: 20,
            ),
            label: Text(
              "LinkedIn",
              style: AppStyles.textstyle14.copyWith(color: Color(0xff0F172A)),
            ),
          ),
        ),
      ],
    );
  }
}
