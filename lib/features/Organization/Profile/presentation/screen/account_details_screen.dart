import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/field_item.dart';
import '../../../../../core/utils/shared/egyptian_phone_formatter.dart';
import '../../../../../core/utils/shared/get_initials.dart';
import '../../../Post Job/presentation/widget/custom_dropdown_menu.dart';
import '../controller/profile_cubit.dart';
import '../widgets/company_photo_picker_2.dart';
import '../widgets/pop_action_menu.dart';
import '../widgets2/change_email/change_email_steps.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  // Personal Info
  late TextEditingController photoCompanyController;
  late TextEditingController phoneController;
  late TextEditingController companyNameController;
  late TextEditingController industryController;
  late GlobalKey<FormState> accountDetailsKey;
  bool _isInitialized = false;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();
    photoCompanyController = TextEditingController();
    companyNameController = TextEditingController();
    industryController = TextEditingController();
    phoneController = TextEditingController();
    accountDetailsKey = GlobalKey<FormState>();

    final cubit = context.read<ProfileCubit>();
    cubit.resetChangeAccountDetailsState();
    if (cubit.state.companyAccount != null) {
      final account = cubit.state.companyAccount!;
      companyNameController.text = account.name;
      phoneController.text = account.phoneNumber;
      photoCompanyController.text = account.photo;
      if (account.industry.isNotEmpty) {
        cubit.changeSelectedIndustry(account.industry);
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
    photoCompanyController.dispose();
    companyNameController.dispose();
    industryController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return SafeArea(
      child: Scaffold(
        body: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (previous, current) =>
              previous.changeAccountDetailsState != current.changeAccountDetailsState,
          listener: (context, state) {
            if (state.changeAccountDetailsState == RequestState.success && !_isPopped) {
              _isPopped = true;
              Navigator.pop(context);
            }
          },
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state.getCompanyAccountState == RequestState.success && state.companyAccount != null) {
                if (!_isInitialized) {
                  companyNameController.text = state.companyAccount!.name;
                  phoneController.text = state.companyAccount!.phoneNumber;
                  photoCompanyController.text = state.companyAccount!.photo;
                  if (state.companyAccount!.industry.isNotEmpty) {
                    context.read<ProfileCubit>().changeSelectedIndustry(state.companyAccount!.industry);
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
                          initials: GetInitials.getInitials(state.companyAccount?.name.isNotEmpty == true ? state.companyAccount!.name : 'Tech Corp Inc.'),
                          imageUrl: state.companyAccount?.photo,
                          onImageSelected: (image) {
                            if (image != null) {
                              photoCompanyController.text = image.path;
                            } else {
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
                      CustomDropdownMenu(
                        title: "Industry",
                        hint: '',
                        items: cubit.industries,
                        value: state.selectedIndustry,
                        onChanged: (val) => cubit.changeSelectedIndustry(val!),
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
                          final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                          if (digitsOnly.length != 11) {
                            return "Please enter a valid 11-digit phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 16),
                      const Text(
                        'Email address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Used for login and notifications',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF94A3B8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Text(
                                        state.companyEmail ?? 'mahmoud.m@gmail.com',
                                        maxLines: 1,
                                        softWrap: false,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF475569),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<ProfileCubit>(),
                                    child: ChangeEmailSteps(
                                      currentEmail: state.companyEmail ?? 'mahmoud.m@gmail.com',
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      ButtonAction(
                        title: 'Save Changes',
                        isLoading: state.changeAccountDetailsState == RequestState.loading,
                        onPressed: () {
                          if (accountDetailsKey.currentState!.validate()) {
                            cubit.updateCompanyInfo(
                              name: companyNameController.text,
                              industry: state.selectedIndustry ?? '',
                              phoneNumber: phoneController.text.replaceAll(RegExp(r'\D'), ''),
                              photoPath: photoCompanyController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
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