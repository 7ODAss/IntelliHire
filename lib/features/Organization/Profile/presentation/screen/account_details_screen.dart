import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/my_form_field.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/egyptian_phone_formatter.dart';
import '../../../../../core/utils/shared/get_initials.dart';
import '../../../../auth/presentation/signup/company/widget/company_photo_picker.dart';
import '../../../Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../../../Post Job/presentation/widget/post_job_text_field.dart';
import '../controller/profile_cubit.dart';
import '../widgets/company_photo_picker_2.dart';
import '../widgets/pop_action_menu.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  // Personal Info
  late TextEditingController photoCompanyController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController companyNameController;
  late TextEditingController industryController;
  late GlobalKey<FormState> accountDetailsKey;

  @override
  void initState() {
    super.initState();
    photoCompanyController = TextEditingController();
    companyNameController = TextEditingController();
    industryController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    accountDetailsKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    photoCompanyController.dispose();
    companyNameController.dispose();
    industryController.dispose();
    emailController.dispose();
    phoneController.dispose();
    accountDetailsKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: accountDetailsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopActionMenu(title: 'Account Details'),
                  const SizedBox(height: 16),
                  CompanyPhotoPicker2(
                      initials: GetInitials.getInitials('Tech Corp Inc.'),
                      onImageSelected: (image) {
                        if (image != null) {
                          photoCompanyController.text = image.path;
                        } else {
                          // لو الصورة اتمسحت فضي الكنترولر أو المتغير
                          photoCompanyController.text = '';
                        }
                      }
                  ),
                  const SizedBox(height: 32),
                  FieldItem(
                    controller: companyNameController,
                    title: 'Company Name',
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  BlocSelector<ProfileCubit, ProfileState, String?>(
                    selector: (state) {
                      return state.selectedIndustry;
                    },
                    builder: (context, state) {
                      return CustomDropdownMenu(
                        title: "Industry",
                        hint: '',
                        items: cubit.industries,
                        value: state,
                        onChanged: (val) => cubit.changeSelectedIndustry(val!),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FieldItem(
                    controller: emailController,
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
                  const SizedBox(height: 48),
                  ButtonAction(
                    title: 'Save Changes',
                    onPressed: () {
                      if (accountDetailsKey.currentState!.validate()) {
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