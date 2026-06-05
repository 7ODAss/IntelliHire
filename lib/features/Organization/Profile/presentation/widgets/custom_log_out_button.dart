import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_style.dart';

class CustomLogOutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomLogOutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // لون خلفية الزرار زي الـ Card
        foregroundColor: const Color(0xFFEF4444), // لون تأثير الضغطة (Ripple)
        elevation: 2, // ظل خفيف عشان يديك نفس إحساس الـ Card
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // حواف دائرية زي الـ Card
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max, // عشان ياخد العرض المتاح، لو عايزه صغير خليها min
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFF1F1),
            radius: 25,
            child: Icon(
              Icons.logout,
              color: Color(0xFFEF4444),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Logout',
            style: AppTextStyle.accountNamePostScreen.copyWith(
              color: const Color(0xFFEF4444),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
