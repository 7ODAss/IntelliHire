import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
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
  late TextEditingController addressController;
  bool _isInitialized = false;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    websiteController = TextEditingController();
    aboutCompanyController = TextEditingController();
    addressController = TextEditingController();
    companyDetailsKey = GlobalKey<FormState>();

    final cubit = context.read<ProfileCubit>();
    cubit.resetChangeAboutCompanyState();
    if (cubit.state.companyAccount != null) {
      final account = cubit.state.companyAccount!;
      aboutCompanyController.text = account.about;
      cubit.linkCompanyController.text = account.websiteUrl;
      if (account.locations.isNotEmpty) {
        final loc = account.locations.first;
        addressController.text = loc.address;
        cubit.changeSelectedCountry(loc.country);
        cubit.changeSelectedGovernorate(loc.governorate);
      }
      _isInitialized = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getCompanyAccountDetails();
      }
    });
  }

  @override
  void dispose() {
    websiteController.dispose();
    aboutCompanyController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.changeAboutCompanyState != current.changeAboutCompanyState,
          listener: (context, state) {
            if (state.changeAboutCompanyState == RequestState.success && !_isPopped) {
              _isPopped = true;
              Navigator.pop(context);
            }
          },
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.getCompanyAccountState == RequestState.success && state.companyAccount != null) {
                if (!_isInitialized) {
                  aboutCompanyController.text = state.companyAccount!.about;
                  cubit.linkCompanyController.text = state.companyAccount!.websiteUrl;
                  if (state.companyAccount!.locations.isNotEmpty) {
                    final loc = state.companyAccount!.locations.first;
                    addressController.text = loc.address;
                    context.read<ProfileCubit>().changeSelectedCountry(loc.country);
                    context.read<ProfileCubit>().changeSelectedGovernorate(loc.governorate);
                  }
                  _isInitialized = true;
                }
              }
            },
            builder: (context, state) {
            if (state.getCompanyAccountState == RequestState.loading && !_isInitialized) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: companyDetailsKey,
                child: Column(
                  children: [
                    const PopActionMenu(title: 'About Company'),
                    const SizedBox(height: 16),
                    LocationCard(
                      cubit: cubit,
                      state: state,
                      addressController: addressController,
                    ),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: aboutCompanyController,
                      title: 'About Company',
                      hintText: 'Enter company description...',
                      type: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    FieldItem(
                      controller: cubit.linkCompanyController,
                      title: 'Website or LinkedIn URL',
                      type: TextInputType.text,
                      hintText: 'https://www.company.com',
                    ),
                    const SizedBox(height: 24),
                    ButtonAction(
                      title: 'Save Changes',
                      isLoading: state.changeAboutCompanyState == RequestState.loading,
                      onPressed: () {
                        if (companyDetailsKey.currentState!.validate()) {
                          cubit.updateCompanyAbout(
                            about: aboutCompanyController.text,
                            websiteUrl: cubit.linkCompanyController.text,
                            country: state.selectedCountry ?? '',
                            government: state.selectedGovernorate ?? '',
                            city: addressController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}
