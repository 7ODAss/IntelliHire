import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/signup_action.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../../Post Job/presentation/widget/post_job_text_field.dart';
import '../controller/profile_cubit.dart';
import '../widgets/location_action.dart';
import '../widgets/location_card.dart';
import '../widgets/location_items.dart';
import '../widgets/locations_list.dart';
import '../widgets/pop_action_menu.dart';

class CompanyDetails extends StatelessWidget {
  const CompanyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.companyDetailsKey,
                child: Column(
                  children: [
                    PopActionMenu(title: 'Company Details'),
                    const SizedBox(height: 16),
                    PostJobTextField(
                      title: 'Company Name',
                      hint: 'Enter company name',
                      controller: cubit.companyNameController,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdownMenu(
                      title: "Industry",
                      hint: 'Select Industry',
                      items: cubit.industries,
                      value: cubit.state.selectedIndustry,
                      onChanged: (val) => cubit.changeSelectedIndustry(val!),
                    ),
                    const SizedBox(height: 16),
                    LocationCard(cubit: cubit,state: state,),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: cubit.linkCompanyController,
                      title: 'Website or LinkedIn URL',
                      type: TextInputType.text,
                      hintText: 'https://www.company.com',
                    ),
                    const SizedBox(height: 24),
                    SignupAction(title: 'Save Changes', onPressed: () {}),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
