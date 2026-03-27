import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.5, 0.5, 1.0],
            colors: [
              Colors.white,
              Colors.white,
              Color(0xFF0F172A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(60),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 48,
            ),
            child: Form(
              key: cubit.locationFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationSelectionSection(cubit: cubit),
                    const SizedBox(height: 16),
                    // Address Field
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
                        // 2. Check minimum length (so they don't just type "St 9")
                        if (cleanAddress.length < 10) {
                          return 'Please provide a more specific address (min 10 characters)';
                        }
                        // 3. Ensure it contains actual letters, not just numbers
                        // Note: \u0600-\u06FF allows Arabic letters to pass validation too!
                        if (!RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(cleanAddress)) {
                          return 'Address must contain text, not just numbers';
                        }

                        return null; // Passes all checks!
                      },
                    ),

                    const SizedBox(height: 48),

                    // Next Button
                    ButtonAction(
                      title: 'Next',
                      onPressed: () {
                        onNext();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
