import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/my_form_field.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/egyptian_phone_formatter.dart';
import '../controller/profile_cubit.dart';
import '../widgets/pop_action_menu.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: cubit.personalInfoKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopActionMenu(title: 'Personal Information'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Stack(
                          alignment: AlignmentGeometry.bottomRight,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColor.iconProfileColor,
                                border: Border.all(
                                  color: AppColor.iconProfileBorderColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(150),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Tc',
                                  style: AppTextStyle.iconNamePostScreen,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: AppColor.iconProfileBorderColor,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 32),

                FieldItem(
                  controller: cubit.emailController,
                  title: 'Work Email',
                  type: TextInputType.text,
                  prefixIcon: Icons.email_outlined,
                  prefixIconColor: Color(0xFFB4ADAE),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Work email is required";
                    }
                    if (!value.contains('gmail')) {
                      return "Please enter a valid work email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FieldItem(
                  controller: cubit.phoneController,
                  title: 'Phone Number',
                  type: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  prefixIconColor: Color(0xFFB4ADAE),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    EgyptianPhoneFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }
                    // Length is 14 because: 11 digits + 3 spaces
                    if (value.length < 14) {
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                ButtonAction(
                  title: 'Save Changes',
                  onPressed: () {
                    if (cubit.personalInfoKey.currentState!.validate()) {
                      // cubit.updateProfile();
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
