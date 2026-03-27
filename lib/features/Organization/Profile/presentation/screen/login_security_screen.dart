import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../auth/presentation/login/widget/button_action.dart';
import '../../../../auth/presentation/login/widget/field_item.dart';
import '../controller/profile_cubit.dart';
import '../widgets/pop_action_menu.dart';

class LoginSecurityScreen extends StatelessWidget {
  const LoginSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: cubit.securityInfoKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopActionMenu(title: 'Login & Security',),
                const SizedBox(height: 32),
                FieldItem(
                  controller: cubit.currentPassController,
                  title: 'Current Password',
                  hintText: 'Enter current password',
                  type: TextInputType.text,
                  prefixIcon: Icons.lock_outlined,
                  prefixIconColor: Color(0xFFB4ADAE),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    // if (!value.contains('gmail')) { //check if current password in like he write
                    //   return "Don\'t your current password";
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FieldItem(
                  controller: cubit.newPassController,
                  title: 'New Password',
                  hintText: 'Enter new password',
                  type: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock_outlined,
                  prefixIconColor: Color(0xFFB4ADAE),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }
                    if (value != cubit.currentPassController.toString()) {
                      return "New password don't match current password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                ButtonAction(
                  title: 'Update Password',
                  onPressed: () {
                    if (cubit.securityInfoKey.currentState!.validate()) {
                      // cubit.updateProfile();
                    }
                  },
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFD6D6D6)),
                const SizedBox(height: 48),
                Text('Account Management', style: AppTextStyle.fieldTitleStyle.copyWith(fontSize: 16)),
                Text(
                  'Deleting your account is a permanent action and cannot be undone.',
                  style: AppTextStyle.fieldTitleStyle.copyWith(
                    color: Color(0xFF475569),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsetsGeometry.zero,
                  horizontalTitleGap: 0,
                  minLeadingWidth: 0,
                  onTap: (){
                    cubit.showDiscardDialog(context);
                  } , // delete account function in cubit
                  title: Text(
                    'Delete Account',
                    style: AppTextStyle.fieldTitleStyle.copyWith(
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  leading: Icon(
                    Icons.delete_outline_outlined,
                    size: 25,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
