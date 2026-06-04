import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/widgets/delete_account_confirm_dialog.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_password/otp_step_change_password.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/delete_account_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/optionfield.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/pop_action_menu.dart';

class LoginAndSecurityScreen extends StatelessWidget {
  const LoginAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopActionMenu(title: 'Login & Security'),
            const SizedBox(height: 32),

            OptionField(
              icon: Icons.lock_outlined,
              categoryName: 'Change Password',
              options: ['Update your account password'],
              fun: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpStepChangePassword(),
                  ),
                );
              },
            ),

            const SizedBox(height: 48),
            Text(
              'Account Management',
              style: AppTextStyle.fieldTitleStyle.copyWith(fontSize: 16),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DeleteAccountScreen();
                      },
                    ),
                  );
                },
                title: Text(
                  'Delete Account',
                  style: AppTextStyle.fieldTitleStyle.copyWith(
                    color: const Color(0xFFDC2626),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'This action cannot be undone',
                    style: TextStyle(color: Color(0xFFEF4444), fontSize: 12),
                  ),
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 22,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
