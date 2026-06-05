import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/context_extension.dart';
import 'package:intelli_hire/features/candidate/bottom%20_navigation/controller/bottom_nav_candidate_cubit.dart'; // تأكد من الـ import ده
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/candidate_photo_picker.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/widgets/change_email/change_email_steps.dart';

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
  // 🌟 مسار ملف الصورة المحلي الجديد (بيبدأ بـ null)
  File? _selectedLocalImage;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late GlobalKey<FormState> personalInfoKey;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    personalInfoKey = GlobalKey<FormState>();
    // 🌟 Reset personalInfoState when screen is opened to clear any stale success/error state from the singleton cubit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CandidateProfileCubit>().resetPersonalInfoState();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CandidateProfileCubit>();

    return SafeArea(
      child: BlocListener<CandidateProfileCubit, CandidateProfileState>(
        // 🌟 Added listenWhen to only trigger when changePersonalInfoState changes.
        // This prevents the listener from reacting to other state changes (like loadProfile emissions)
        // that inherit the 'success' value, which previously caused the snackbar to show 3 times.
        listenWhen: (previous, current) =>
            previous.changePersonalInfoState != current.changePersonalInfoState,
        listener: (context, state) {
          if (state.changePersonalInfoState == RequestState.success) {
            context.showSnackBar(
              'Profile updated successfully',
              type: SnackBarType.success,
            );
            // 🌟 بعد النجاح، اطلب داتا البروفايل الجديدة عشان تسمع في الـ Header والـ Profile أوتوماتيك
          } else if (state.changePersonalInfoState == RequestState.error) {
            context.showSnackBar(
              'Failed to update profile',
              type: SnackBarType.error,
            );
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: personalInfoKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 ربط زرار الرجوع بالـ Cubit بتاع الـ Navigation عشان يرجع صح
                    PopActionMenu(title: 'Personal Information'),
                    const SizedBox(height: 16),
                    CandidatePhotoPicker(
                      imageUrl: widget.photo,
                      onImageSelected: (image) {
                        setState(() {
                          _selectedLocalImage =
                              image; // حفظ كائن الملف الحقيقي المختار
                        });
                      },
                      initials: GetInitials.getInitials(
                        cubit.state.candidateProfileModel?.fullName ??
                            widget.name,
                      ),
                    ),
                    const SizedBox(height: 32),

                    FieldItem(
                      controller: nameController,
                      title: 'Full Name',
                      type: TextInputType.text,
                      prefixIcon: Icons.person_outline,
                      prefixIconColor: const Color(0xFFB4ADAE),
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
                      prefixIconColor: const Color(0xFFB4ADAE),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        EgyptianPhoneFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.replaceAll(' ', '').length < 11) {
                          return "Please enter a valid phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFD6D6D6), thickness: 1),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FieldItem(
                            controller: emailController,
                            enabled: false,
                            title:
                                'Email address\nUsed for login and notifications',
                            type: TextInputType.text,
                            prefixIcon: Icons.email_outlined,
                            prefixIconColor: const Color(0xFFB4ADAE),
                            validator: (value) =>
                                null, // الـ Field معطل كدة كدة
                          ),
                        ),
                        const SizedBox(width: 16),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: cubit.state.candidateProfileModel == null
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: cubit,
                                              child: ChangeEmailSteps(
                                                currentEmail: cubit
                                                    .state
                                                    .candidateProfileModel!
                                                    .email,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                              ),
                              child: Text(
                                'Change',
                                style: AppTextStyle.candidateFunStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    BlocSelector<
                      CandidateProfileCubit,
                      CandidateProfileState,
                      bool
                    >(
                      selector: (state) =>
                          state.changePersonalInfoState == RequestState.loading,
                      builder: (context, isLoading) {
                        return ButtonAction(
                          title: 'Save Changes',
                          isLoading: isLoading,
                          onPressed: () {
                            if (personalInfoKey.currentState!.validate()) {
                              final cleanPhoneNumber = phoneController.text
                                  .replaceAll(' ', '');

                              // 🌟 إرسال البيانات النظيفة؛ والـ image هتروح بـ null لو متمش اختيار صورة جديدة
                              cubit.updateProfile(
                                nameController.text,
                                cleanPhoneNumber,
                                _selectedLocalImage,
                              );
                            }
                          },
                        );
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
