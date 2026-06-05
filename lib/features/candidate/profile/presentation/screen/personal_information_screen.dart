import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/candidate_photo_picker.dart';

import '../../../../../core/service/service_locator.dart';
import '../../../../../core/utils/shared/egyptian_phone_formatter.dart';
import '../../../../../core/utils/shared/get_initials.dart';
import '../controller/candidate_profile_cubit.dart';
import '../widgets/pop_action_menu.dart';

class PersonalInformationScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String photo;

  const PersonalInformationScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  // Personal Info
  final cubit = getIt<CandidateProfileCubit>();
  late TextEditingController photoController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late GlobalKey<FormState> personalInfoKey;

  @override
  void initState() {
    super.initState();
    photoController = TextEditingController(text: widget.photo);
    nameController = TextEditingController(
      text: widget.name,
    );
    phoneController = TextEditingController(
      text: widget.phone,
    );
    emailController = TextEditingController(
      text: widget.email,
    );
    personalInfoKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    photoController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CandidateProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: personalInfoKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopActionMenu(title: 'Personal Information'),
                  const SizedBox(height: 16),
                  CandidatePhotoPicker(
                    onImageSelected: (image) {
                      photoController.text = image.path;
                    },
                    initials: GetInitials.getInitials(
                      cubit.state.candidateProfileModel!.fullName,
                    ),
                  ),
                  const SizedBox(height: 32),

                  FieldItem(
                    controller: nameController,
                    title: 'Full Name',
                    type: TextInputType.text,
                    prefixIcon: Icons.person_outline,
                    prefixIconColor: Color(0xFFB4ADAE),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      if (value.length < 3) {
                        return "Please enter a valid name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FieldItem(
                    controller: phoneController,
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
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFD6D6D6), thickness: 1),
                  const SizedBox(height: 16),
                  FieldItem(
                    controller: emailController,
                    title: 'Email address\nUsed for login and notifications',
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
                  const SizedBox(height: 48),
                  ButtonAction(
                    title: 'Save Changes',
                    onPressed: () {
                      if (personalInfoKey.currentState!.validate()) {
                        // cubit.updateProfile();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
