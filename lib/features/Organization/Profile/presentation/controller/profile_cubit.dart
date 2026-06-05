import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/user_profile_log_out_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/update_company_info_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/update_company_about_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/get_company_account_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/change_email_password_request_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/change_email_request_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/change_email_confirm_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/request_password_change_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/send_otp_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/confirm_password_change_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/delete_company_account_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/data/model/company_account_model.dart';

import '../../domain/entity/company_location.dart';
import '../widgets/delete_account_confirm_dialog.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LogOutUserProfileUseCase logOutUserProfileUseCase;
  final UpdateCompanyInfoUseCase updateCompanyInfoUseCase;
  final UpdateCompanyAboutUseCase updateCompanyAboutUseCase;
  final GetCompanyAccountUseCase getCompanyAccountUseCase;
  final ChangeEmailPasswordRequestUseCase changeEmailPasswordRequestUseCase;
  final ChangeEmailRequestUseCase changeEmailRequestUseCase;
  final ChangeEmailConfirmUseCase changeEmailConfirmUseCase;
  final RequestPasswordChangeUseCase requestPasswordChangeUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final ConfirmPasswordChangeUseCase confirmPasswordChangeUseCase;
  final DeleteCompanyAccountUseCase deleteCompanyAccountUseCase;

  ProfileCubit(
    this.logOutUserProfileUseCase,
    this.updateCompanyInfoUseCase,
    this.updateCompanyAboutUseCase,
    this.getCompanyAccountUseCase,
    this.changeEmailPasswordRequestUseCase,
    this.changeEmailRequestUseCase,
    this.changeEmailConfirmUseCase,
    this.requestPasswordChangeUseCase,
    this.sendOtpUseCase,
    this.confirmPasswordChangeUseCase,
    this.deleteCompanyAccountUseCase,
  ) : super(ProfileState());

  // Security
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final GlobalKey<FormState> securityInfoKey = GlobalKey<FormState>();


  final List<String> countries = [
    'Egypt',
    'Saudi Arabia',
    'UAE',
    'Kuwait',
    'Qatar',
  ];
  final Map<String, List<String>> countryGovernorates = {
    'Egypt': [
      'Alexandria',
      'Aswan',
      'Asyut',
      'Beheira',
      'Beni Suef',
      'Cairo',
      'Dakahlia',
      'Damietta',
      'Fayoum',
      'Gharbia',
      'Giza',
      'Ismailia',
      ' Kafr El Sheikh',
      'Luxor',
      'Matrouh',
      'Minya',
      'Monofiya',
      'New Valley',
      'North Sinai',
      'Port Said',
      'Qalioubiya',
      'Qena',
      'Red Sea',
      'Sharqia',
      'Sohag',
      'South Sinai',
      'Suez',
    ],
    'Saudi Arabia': [
      'Makkah',
      'Riyadh',
      'Eastern',
      'Madinah',
      'Asir',
      'Tabuk',
      'Jazan',
      'Al-Qassim',
      'Ha\'il',
      'Northern Borders',
      'Najran',
      'Al-Bahah',
    ],
    'UAE': [
      'Abu Dhabi',
      'Dubai',
      'Sharjah',
      'Ajman',
      'Umm Al Quwain',
      'Ras Al Khaimah',
      'Fujairah',
    ],
    'Kuwait': [
      'Al Asimah',
      'Hawalli',
      'Farwaniya',
      'Mubarak Al-Kabeer',
      'Ahmadi',
      'Jahra',
    ],
    'Qatar': [
      'Doha',
      'Al Rayyan',
      'Al Wakrah',
      'Al Khor',
      'Al Shamal',
      'Umm Salal',
      'Al Daayen',
      'Al Shahaniya',
    ],
  };

  final List<String> industries = [
    'Software Engineering & Development',
    'Data & Artificial Intelligence',
    'IT Infrastructure & Security',
    'Hardware & Embedded Systems',
    'Enterprise Systems & Solutions',
    'IT Services & Consulting',
  ];

  final TextEditingController linkCompanyController = TextEditingController();

  void addCompanyLocation({required String detailedAddress}) {
    if (state.selectedCountry != null &&
        state.selectedGovernorate != null &&
        detailedAddress.isNotEmpty) {
      final newLocation = CompanyLocation(
        country: state.selectedCountry!,
        governorate: state.selectedGovernorate!,
        address:detailedAddress,
      );

      final currentLocations = state.locations ?? [];

      final updatedLocation = [...currentLocations, newLocation];

      emit(
        state.copyWith(
          locations: updatedLocation,
          selectedCountry: '',
          selectedGovernorate: '',
        ),
      );
    }
  }

  void removeCompanyLocation(int index) {
    final currentLocations = state.locations ?? [];
    final List<CompanyLocation> updatedLocations = List.from(currentLocations);
    updatedLocations.removeAt(index);
    emit(state.copyWith(locations: updatedLocations));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: this,
          child: const DeleteAccountConfirmDialog(),
        );
      },
    );
  }

  void changeSelectedIndustry(String industry) {
    emit(state.copyWith(selectedIndustry: industry));
  }

  void changeSelectedCountry(String country) {
    emit(state.copyWith(selectedCountry: country));
  }

  void changeSelectedGovernorate(String governorate) {
    emit(state.copyWith(selectedGovernorate: governorate));
  }

  Future<void> logout() async {
    emit(state.copyWith(userProfileLogOutState: RequestState.loading));
    final result = await logOutUserProfileUseCase(NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          userProfileLogOutMessage: l.message,
          userProfileLogOutState: RequestState.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          userProfileLogOutState: RequestState.success,
        ),
      ),
    );
  }

  Future<void> updateCompanyInfo({
    required String name,
    required String industry,
    required String phoneNumber,
    String? photoPath,
  }) async {
    emit(state.copyWith(changeAccountDetailsState: RequestState.loading));
    print("--- [CUBIT ACTION] updateCompanyInfo ---");
    print("Parameters: Name=$name, Industry=$industry, PhoneNumber=$phoneNumber, PhotoPath=$photoPath");

    final result = await updateCompanyInfoUseCase(
      UpdateCompanyInfoParams(
        name: name,
        industry: industry,
        phoneNumber: phoneNumber,
        photoPath: photoPath,
      ),
    );

    result.fold(
      (failure) {
        print("Cubit updateCompanyInfo Fail: ${failure.message}");
        emit(state.copyWith(
          changeAccountDetailsState: RequestState.error,
          changeAccountDetailsMessage: failure.message,
        ));
      },
      (success) {
        print("Cubit updateCompanyInfo Success!");
        emit(state.copyWith(
          changeAccountDetailsState: RequestState.success,
          changeAccountDetailsMessage: "Company details updated successfully",
        ));
        getCompanyAccountDetails();
        try {
          getIt<HomeOrganizationCubit>().fetchDashboard();
        } catch (e) {
          print("Failed to fetch dashboard: $e");
        }
      },
    );
  }

  Future<void> updateCompanyAbout({
    required String about,
    required String websiteUrl,
    required String country,
    required String government,
    required String city,
  }) async {
    emit(state.copyWith(changeAboutCompanyState: RequestState.loading));
    print("--- [CUBIT ACTION] updateCompanyAbout ---");
    print("Parameters: About=$about, WebsiteUrl=$websiteUrl, Country=$country, Government=$government, City=$city");

    final result = await updateCompanyAboutUseCase(
      UpdateCompanyAboutParams(
        about: about,
        websiteUrl: websiteUrl,
        country: country,
        government: government,
        city: city,
      ),
    );

    result.fold(
      (failure) {
        print("Cubit updateCompanyAbout Fail: ${failure.message}");
        emit(state.copyWith(
          changeAboutCompanyState: RequestState.error,
          changeAboutCompanyMessage: failure.message,
        ));
      },
      (success) {
        print("Cubit updateCompanyAbout Success!");
        emit(state.copyWith(
          changeAboutCompanyState: RequestState.success,
          changeAboutCompanyMessage: "Company description/location updated successfully",
        ));
        getCompanyAccountDetails();
      },
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final email = state.companyEmail ?? state.companyAccount?.email ?? '';
    await requestPasswordChange(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> requestPasswordChange({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(
      changePasswordRequestState: RequestState.loading,
      pendingCurrentPassword: currentPassword,
      pendingNewPassword: newPassword,
    ));
    print("--- [CUBIT ACTION] requestPasswordChange ---");
    print("Email: $email");

    final result = await requestPasswordChangeUseCase(email);

    result.fold(
      (failure) {
        print("requestPasswordChange failed: ${failure.message}");
        emit(state.copyWith(
          changePasswordRequestState: RequestState.error,
          changePasswordRequestMessage: failure.message,
        ));
      },
      (success) {
        print("requestPasswordChange success!");
        emit(state.copyWith(
          changePasswordRequestState: RequestState.success,
          changePasswordRequestMessage: "Verification code sent to $email",
        ));
      },
    );
  }

  Future<void> verifyPasswordOtp({
    required String email,
    required String code,
  }) async {
    emit(state.copyWith(changePasswordOtpState: RequestState.loading));
    print("--- [CUBIT ACTION] verifyPasswordOtp ---");
    print("Email: $email, Code: $code");

    final otpResult = await sendOtpUseCase(SendOtpParams(email: email, code: code));

    await otpResult.fold(
      (failure) async {
        print("sendOtp failed: ${failure.message}");
        emit(state.copyWith(
          changePasswordOtpState: RequestState.error,
          changePasswordOtpMessage: failure.message,
        ));
      },
      (token) async {
        print("sendOtp success, token obtained: $token");
        final confirmResult = await confirmPasswordChangeUseCase(
          ConfirmPasswordChangeParams(
            email: email,
            token: token,
            currentPassword: state.pendingCurrentPassword ?? '',
            newPassword: state.pendingNewPassword ?? '',
            confirmPassword: state.pendingNewPassword ?? '',
          ),
        );

        confirmResult.fold(
          (confirmFailure) {
            print("confirmPasswordChange failed: ${confirmFailure.message}");
            emit(state.copyWith(
              changePasswordOtpState: RequestState.error,
              changePasswordOtpMessage: confirmFailure.message,
            ));
          },
          (confirmSuccess) {
            print("confirmPasswordChange success!");
            emit(state.copyWith(
              changePasswordOtpState: RequestState.success,
              changePasswordOtpMessage: "Password updated successfully!",
              pendingCurrentPassword: '',
              pendingNewPassword: '',
            ));
          },
        );
      },
    );
  }

  Future<void> resendPasswordOtp({required String email}) async {
    print("--- [CUBIT ACTION] resendPasswordOtp ---");
    final result = await requestPasswordChangeUseCase(email);
    result.fold(
      (failure) {
        print("resendPasswordOtp failed: ${failure.message}");
      },
      (success) {
        print("resendPasswordOtp success!");
      },
    );
  }

  Future<void> deleteCompanyAccount({
    required String email,
    required String currentPassword,
  }) async {
    emit(state.copyWith(deleteAccountState: RequestState.loading));
    print("--- [CUBIT ACTION] deleteCompanyAccount ---");
    print("Email: $email");

    final result = await deleteCompanyAccountUseCase(
      DeleteCompanyAccountParams(
        email: email,
        currentPassword: currentPassword,
      ),
    );

    result.fold(
      (failure) {
        print("deleteCompanyAccount failed: ${failure.message}");
        emit(state.copyWith(
          deleteAccountState: RequestState.error,
          deleteAccountMessage: failure.message,
        ));
      },
      (success) async {
        print("deleteCompanyAccount success!");
        emit(state.copyWith(
          deleteAccountState: RequestState.success,
          deleteAccountMessage: "Account deleted successfully",
        ));
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'userType');
      },
    );
  }

  void deleteAccount() {
    print("--- [CUBIT ACTION] deleteAccount ---");
  }

  void resetPasswordChangeStates() {
    emit(state.copyWith(
      changePasswordRequestState: RequestState.initial,
      changePasswordRequestMessage: '',
      changePasswordOtpState: RequestState.initial,
      changePasswordOtpMessage: '',
      pendingCurrentPassword: '',
      pendingNewPassword: '',
    ));
  }

  void resetPasswordRequestState() {
    emit(state.copyWith(
      changePasswordRequestState: RequestState.initial,
    ));
  }

  void resetDeleteAccountState() {
    emit(state.copyWith(
      deleteAccountState: RequestState.initial,
      deleteAccountMessage: '',
    ));
  }

  void changeObsecure() {
    emit(state.copyWith(obsecure: !state.obsecure));
  }

  void resetEmailChangeStepsStates() {
    emit(state.copyWith(
      changeEmailPasswordCheckState: RequestState.initial,
      changeEmailPasswordCheckMessage: '',
      changeEmailEmailCheckState: RequestState.initial,
      changeEmailEmailCheckMessage: '',
    ));
  }

  void resetOtpState() {
    emit(state.copyWith(
      otpState: RequestState.initial,
      otpMessage: '',
    ));
  }

  void resetChangeAccountDetailsState() {
    emit(state.copyWith(
      changeAccountDetailsState: RequestState.initial,
    ));
  }

  void resetChangeAboutCompanyState() {
    emit(state.copyWith(
      changeAboutCompanyState: RequestState.initial,
    ));
  }

  Future<void> getCompanyAccountDetails() async {
    emit(state.copyWith(getCompanyAccountState: RequestState.loading));
    print("--- [CUBIT ACTION] getCompanyAccountDetails ---");

    final result = await getCompanyAccountUseCase(const NoParameters());

    result.fold(
      (failure) {
        print("Cubit getCompanyAccountDetails Fail: ${failure.message}");
        emit(state.copyWith(
          getCompanyAccountState: RequestState.error,
          getCompanyAccountMessage: failure.message,
        ));
      },
      (companyAccount) {
        print("Cubit getCompanyAccountDetails Success!");
        emit(state.copyWith(
          getCompanyAccountState: RequestState.success,
          companyAccount: companyAccount,
          companyEmail: companyAccount.email,
        ));
      },
    );
  }

  Future<void> confirmCurrentPassword({
    required String currentEmail,
    required String currentPassword,
  }) async {
    emit(state.copyWith(changeEmailPasswordCheckState: RequestState.loading));
    print("--- [CUBIT ACTION] confirmCurrentPassword ---");
    print("Current Email: $currentEmail, Current Password: $currentPassword");

    final result = await changeEmailPasswordRequestUseCase(
      ChangeEmailPasswordRequestParams(
        password: currentPassword,
        currentEmail: currentEmail,
      ),
    );

    result.fold(
      (failure) {
        print("confirmCurrentPassword failed: ${failure.message}");
        emit(state.copyWith(
          changeEmailPasswordCheckState: RequestState.error,
          changeEmailPasswordCheckMessage: failure.message,
        ));
      },
      (r) {
        print("confirmCurrentPassword success");
        emit(state.copyWith(
          changeEmailPasswordCheckState: RequestState.success,
          changeEmailPasswordCheckMessage: "Password verified successfully",
        ));
      },
    );
  }

  Future<void> sendCode({
    required String currentEmail,
    required String newEmail,
  }) async {
    emit(state.copyWith(changeEmailEmailCheckState: RequestState.loading));
    print("--- [CUBIT ACTION] sendCode (Change Email) ---");
    print("Current Email: $currentEmail, New Email: $newEmail");

    final result = await changeEmailRequestUseCase(
      ChangeEmailRequestParams(
        currentEmail: currentEmail,
        newEmail: newEmail,
      ),
    );

    result.fold(
      (failure) {
        print("sendCode failed: ${failure.message}");
        emit(state.copyWith(
          changeEmailEmailCheckState: RequestState.error,
          changeEmailEmailCheckMessage: failure.message,
        ));
      },
      (r) {
        print("sendCode success");
        emit(state.copyWith(
          changeEmailEmailCheckState: RequestState.success,
          changeEmailEmailCheckMessage: "Verification code sent to $newEmail",
        ));
      },
    );
  }

  Future<void> verifyCode({
    required String currentEmail,
    required String newEmail,
    required String code,
  }) async {
    emit(state.copyWith(otpState: RequestState.loading));
    print("--- [CUBIT ACTION] verifyCode (Change Email) ---");
    print("Current Email: $currentEmail, New Email: $newEmail, Code: $code");

    final result = await changeEmailConfirmUseCase(
      ChangeEmailConfirmParams(
        currentEmail: currentEmail,
        newEmail: newEmail,
        code: code,
      ),
    );

    result.fold(
      (failure) {
        print("verifyCode failed: ${failure.message}");
        emit(state.copyWith(
          otpState: RequestState.error,
          otpMessage: failure.message,
        ));
      },
      (r) {
        print("verifyCode success");
        emit(state.copyWith(
          otpState: RequestState.success,
          otpMessage: "Email updated successfully!",
          companyEmail: newEmail,
        ));
        getCompanyAccountDetails();
      },
    );
  }
}
