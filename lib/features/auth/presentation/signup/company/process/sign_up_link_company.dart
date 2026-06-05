import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../../../../core/enums/snack_bar_type.dart';
import '../../../../../../core/utils/shared/context_extension.dart';
import '../../../../../Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import '../../../../controller/sign_up_cubit/sign_up_cubit.dart';
import '../../../login/widget/button_action.dart';
import '../widget/company_photo_picker.dart';

class SignUpLinkCompany extends StatefulWidget {
  const SignUpLinkCompany({super.key});

  @override
  State<SignUpLinkCompany> createState() => _SignUpLinkCompanyState();
}

class _SignUpLinkCompanyState extends State<SignUpLinkCompany> {
  //company location
  late TextEditingController photoCompanyController;
  late TextEditingController linkCompanyController;
  late TextEditingController aboutCompanyController;
  late GlobalKey<FormState> linkCompanyFormKey;

  @override
  void initState() {
    super.initState();
    photoCompanyController = TextEditingController();
    linkCompanyController = TextEditingController();
    aboutCompanyController = TextEditingController();
    linkCompanyFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    photoCompanyController.dispose();
    linkCompanyController.dispose();
    aboutCompanyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return AuthStepLayout(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Form(
        key: linkCompanyFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CompanyPhotoPicker(
                  onImageSelected: (image) {
                    photoCompanyController.text = image.path;
                  },
                ),
              ),
              const SizedBox(height: 32),
              FieldItem(
                controller: linkCompanyController,
                title: 'Website or LinkedIn URL',
                message: 'Enter your Website Company',
                type: TextInputType.url,
                hintText: 'https://www.company.com',
                 validator: (value) {
                 if (value == null || value.trim().isEmpty) {
                   return 'Please enter a Company Website or LinkedIn URL';
                   }
                   final urlRegExp = RegExp(
                     r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*)?$',
                     caseSensitive: false,
                   );
                   if (!urlRegExp.hasMatch(value.trim())) {
                     return 'Please enter a valid URL (e.g., https://company.com)';
                   }
                   return null;
                 },
              ),
              const SizedBox(height: 32),
              FieldItem(
                controller: aboutCompanyController,
                title: 'About Company',
                hintText:
                    'Tech Crops. is a leading provider of cloud-based software for enterprises.',
                type: TextInputType.multiline,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description of your company';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),
              BlocConsumer<SignUpCubit, SignUpState>(
                listener: (context, state) {
                  if (state.completeSignUpState == RequestState.success) {
                    context.showSnackBar(
                      state.completeSignUpMessage,
                      type: SnackBarType.success,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomBottomNavBarWrapper(),
                      ),
                    );
                  } else if (state.completeSignUpState == RequestState.error) {
                    context.showSnackBar(
                      state.completeSignUpMessage,
                      type: SnackBarType.error,
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ButtonAction(
                        title: 'Complete Registration',
                        isLoading:
                            state.completeSignUpState == RequestState.loading,
                        onPressed: () {
                          if (linkCompanyFormKey.currentState!.validate()) {
                            cubit.completeSignUp(
                              companyLogo: cubit.state.photoCompany,
                              linkCompany: cubit.state.linkCompany,
                              aboutCompany: cubit.state.aboutCompany,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          cubit.completeSignUp(
                            companyLogo: cubit.state.photoCompany.isEmpty ? 'skipped' : cubit.state.photoCompany,
                            linkCompany: cubit.state.linkCompany.isEmpty ? 'skipped' : cubit.state.linkCompany,
                            aboutCompany: cubit.state.aboutCompany.isEmpty ? 'skipped' : cubit.state.aboutCompany,
                          );
                        },
                        child: Text(
                          'Skip this step',
                          style: AppTextStyle.hintTextStyle,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
