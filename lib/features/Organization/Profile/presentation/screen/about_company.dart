import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../../../Post Job/presentation/widget/post_job_text_field.dart';
import '../controller/profile_cubit.dart';
import '../widgets/location_card.dart';
import '../widgets/pop_action_menu.dart';

class AboutCompany extends StatefulWidget {
  const AboutCompany({super.key});

  @override
  State<AboutCompany> createState() => _AboutCompanyState();
}

class _AboutCompanyState extends State<AboutCompany> {
  // Company Details
  late GlobalKey<FormState> companyDetailsKey;
  late TextEditingController websiteController;
  late TextEditingController aboutCompanyController;


  @override
  void initState() {
    super.initState();
    websiteController = TextEditingController();
    aboutCompanyController = TextEditingController();
    companyDetailsKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    websiteController.dispose();
    aboutCompanyController.dispose();
    companyDetailsKey.currentState?.dispose();
  }

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
                key: companyDetailsKey,
                child: Column(
                  children: [
                    PopActionMenu(title: 'About Company'),
                    const SizedBox(height: 16),
                    LocationCard(cubit: cubit,state: state,),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: cubit.linkCompanyController,
                      title: 'Website or LinkedIn URL',
                      type: TextInputType.text,
                      hintText: 'https://www.company.com',
                    ),
                    const SizedBox(height: 24),
                    ButtonAction(title: 'Save Changes', onPressed: () {}),
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
