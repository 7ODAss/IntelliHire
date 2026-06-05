import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_text_field.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProfileSetupCubit>();
    if (profileCubit.phoneNumber != null) {
      _phoneController.text = profileCubit.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Phone Number",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone Number is required";
                  }
                  if (value.length < 10 || value.length > 15) {
                    return 'Invalid phone number length';
                  }
                  return null;
                },
                controller: _phoneController,
              ),
              const SizedBox(height: 48),

              // زرار الانتقال للخطوة التالية
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 1. حفظ الرقم في الـ Cubit المسؤول عن تجهيز البروفايل
                    context.read<ProfileSetupCubit>().setPhoneNumber(
                      _phoneController.text,
                    );

                    // 2. استدعاء الدالة اللي هتحرك الـ IndexedStack أو الـ Switch للخطوة الجاية (رفع الـ CV)
                    widget.onPressed();
                  }
                },
                title: "Next",
              ),
            ],
          ),
        ),
      ),
    );
  }
}