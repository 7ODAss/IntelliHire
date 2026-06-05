import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/shared/auth_step_layout.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../../controller/sign_up_cubit/sign_up_cubit.dart';
import '../../../login/widget/button_action.dart';
import '../widget/custom_search.dart';

class SignUpLocationCompany extends StatefulWidget {
  const SignUpLocationCompany({super.key});

  @override
  State<SignUpLocationCompany> createState() => _SignUpLocationCompanyState();
}

class _SignUpLocationCompanyState extends State<SignUpLocationCompany> {
  late TextEditingController countryController;
  late TextEditingController govController;
  late TextEditingController addressController;
  late GlobalKey<FormState> locationFormKey;
  late SearchController searchCountryController;
  late SearchController searchGovController;

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController();
    govController = TextEditingController();
    addressController = TextEditingController();
    locationFormKey = GlobalKey<FormState>();
    searchCountryController = SearchController();
    searchGovController = SearchController();
  }

  @override
  void dispose() {
    countryController.dispose();
    govController.dispose();
    addressController.dispose();
    searchCountryController.dispose();
    searchGovController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return AuthStepLayout(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 48,
      ),
      child: Form(
        key: locationFormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationSelectionSection(cubit: cubit),
              const SizedBox(height: 16),
              FieldItem(
                controller: addressController,
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
                onPressed: () {
                  if (locationFormKey.currentState!.validate()) {
                    cubit.completeLocationCompany(
                      country: cubit.state.selectedCountry,
                      gov: cubit.state.selectedGovernorate,
                      address: addressController.text,
                    );
                    cubit.nextStep();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
