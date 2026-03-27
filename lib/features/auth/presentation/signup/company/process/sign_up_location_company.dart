import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';

import '../../../../controller/sign_up_cubit.dart';
import '../../../login/widget/button_action.dart';
import '../../widget/custom_search.dart';

class SignUpLocationCompany extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpLocationCompany({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return AuthStepLayout(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 48,
      ),
      child: Form(
        key: cubit.locationFormKey,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationSelectionSection(cubit: cubit),
              const SizedBox(height: 16),
              FieldItem(
                controller: cubit.addressController,
                title: 'Detailed Address',
                message: 'Enter your detailed address',
                type: TextInputType.streetAddress,
                hintText: 'e.g Building 4, Street 9, Maadi',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a detailed address';
                  }
                  String cleanAddress = value.trim();
                  if (cleanAddress.length < 10) {
                    return 'Please provide a more specific address (min 10 characters)';
                  }
                  if (!RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(cleanAddress)) {
                    return 'Address must contain text, not just numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),
              ButtonAction(
                title: 'Next',
                onPressed: onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
