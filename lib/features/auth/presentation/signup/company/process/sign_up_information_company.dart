import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
import 'package:intelli_hire/features/auth/controller/sign_up_cubit/sign_up_cubit.dart';

import '../../../../../Organization/Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../../../login/widget/button_action.dart';
import '../../../login/widget/field_item.dart';

class SignUpInformationCompany extends StatefulWidget {
  const SignUpInformationCompany({super.key});

  @override
  State<SignUpInformationCompany> createState() =>
      _SignUpInformationCompanyState();
}

class _SignUpInformationCompanyState extends State<SignUpInformationCompany> {
  //Company Information
  late TextEditingController workPhoneController ;
  late TextEditingController companyNameController ;
  late TextEditingController industryController ;
  late GlobalKey<FormState> industryFormKey;

  @override
  void initState() {
    super.initState();
    workPhoneController = TextEditingController();
    companyNameController = TextEditingController();
    industryController = TextEditingController();
    industryFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    workPhoneController.dispose();
    companyNameController.dispose();
    industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return AuthStepLayout(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: industryFormKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldItem(
                    controller: workPhoneController,
                    title: 'Phone Number',
                    message: 'Enter Your Phone Number',
                    type: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required";
                      }
                      // Strip spaces if you are using the EgyptianPhoneFormatter
                      String cleanPhone = value.replaceAll(' ', '');
                      // Check if it's at least 8 digits
                      if (cleanPhone.length < 8) {
                        return "Phone number must be at least 8 digits";
                      }
                      // Optional: Ensure it only contains numbers
                      if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
                        return "Phone number must contain only digits";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  FieldItem(
                    controller: companyNameController,
                    title: 'Company Name',
                    message: 'Enter Your Company Name',
                    type: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocSelector<SignUpCubit, SignUpState, String>(
                    selector: (state) {
                      return state.selectedIndustry;
                    },
                    builder: (context, state) {
                      return CustomDropdownMenu(
                        hint: 'Industry',
                        title: "Industry",
                        items: cubit.industries,
                        value: state.isEmpty ? null : state,
                        onChanged: (val) => cubit.changeSelectedIndustry(val!),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ButtonAction(title: 'Next', onPressed: (){
                    if(industryFormKey.currentState!.validate()){
                      cubit.completeInformationCompany(
                        phoneNumber: workPhoneController.text,
                        companyName: companyNameController.text,
                        industry: cubit.state.selectedIndustry,
                      );
                      cubit.nextStep();
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
