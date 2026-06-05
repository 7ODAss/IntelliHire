import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/candidate/home/presentation/controller/home_cubit.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_career_details_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_current_password_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_new_email_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_otp_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_check_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_otp_request_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_verify_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_personal_info_usecase.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../../../Organization/Profile/presentation/widgets/delete_account_confirm_dialog.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/usecases/change_password_candidate_usecase.dart';
import '../../domain/usecases/delete_account_candidate_usecase.dart';
import '../../domain/usecases/log_out_user_candidate_profile_usecase.dart';
import '../../domain/usecases/fetch_candidate_profile_usecases.dart';

part 'candidate_profile_state.dart';

class CandidateProfileCubit extends Cubit<CandidateProfileState> {
  final FetchCandidateProfileUseCase fetchProfileUseCase;
  final ChangePersonalInfoUsecase updateCandidateProfileUseCase;
  final ChangePasswordCandidateUseCase changePasswordCandidateUseCase;
  final DeleteAccountCandidateUseCase deleteAccountCandidateUseCase;
  final ChangeCareerDetailsUseCase changeCareerDetailsUseCase;
  final LogOutUserCandidateProfileUseCase logOutUserCandidateProfileUseCase;
  final ChangeEmailEnterCurrentPasswordUseCase
  changeEmailEnterCurrentPasswordUseCase;
  final ChangeEmailEnterNewEmailUseCase changeEmailEnterNewEmailUseCase;
  final ChangeEmailOtpUseCase changeEmailOtpUseCase;
  final ChangePasswordOtpRequestUseCase changePasswordOtpRequestUseCase;
  final ChangePasswordOtpCheckUseCase changePasswordOtpCheckUseCase;
  final ChangePasswordVerifyUseCase changePasswordVerifyUseCase;

  CandidateProfileCubit(
    this.fetchProfileUseCase,
    this.updateCandidateProfileUseCase,
    this.changePasswordCandidateUseCase,
    this.deleteAccountCandidateUseCase,
    this.changeCareerDetailsUseCase,
    this.logOutUserCandidateProfileUseCase,
    this.changeEmailEnterCurrentPasswordUseCase,
    this.changeEmailEnterNewEmailUseCase,
    this.changeEmailOtpUseCase,
    this.changePasswordOtpRequestUseCase,
    this.changePasswordOtpCheckUseCase,
    this.changePasswordVerifyUseCase,
  ) : super(const CandidateProfileState());

  void resetOtpState() {
    emit(state.copyWith(changeEmailOtpState: RequestState.initial));
  }

  // 🌟 Added to reset changePersonalInfoState to RequestState.initial when entering or leaving the personal info screen to avoid stale states.
  void resetPersonalInfoState() {
    emit(state.copyWith(changePersonalInfoState: RequestState.initial));
  }

  void resetEmailChangeStepsStates() {
    emit(
      state.copyWith(
        changeEmailPasswordCheckState: RequestState.initial,
        changeEmailEmailCheckState: RequestState.initial,
        changeEmailOtpState: RequestState.initial,
      ),
    );
  }

  void changeObsecure() {
    emit(state.copyWith(obsecure: !state.obsecure));
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

  Future<void> logout() async {
    emit(state.copyWith(userProfileCandidateLogOutState: RequestState.loading));
    final result = await logOutUserCandidateProfileUseCase(NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          userProfileCandidateLogOutMessage: l.message,
          userProfileCandidateLogOutState: RequestState.error,
        ),
      ),
      (r) => emit(
        state.copyWith(userProfileCandidateLogOutState: RequestState.success),
      ),
    );
  }

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(status: RequestState.loading));

    final result = await fetchProfileUseCase(const NoParameters());

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: RequestState.error,
            candidateProfileMessage: failure.message,
          ),
        );
      },
      (profile) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: RequestState.success,
            candidateProfileModel: profile,
          ),
        );
      },
    );
  }

  Future<void> updateProfile(
    String fullName,
    String phoneNumber,
    File? image,
  ) async {
    if (state.candidateProfileModel == null) return;
    emit(state.copyWith(changePersonalInfoState: RequestState.loading));
    final result = await updateCandidateProfileUseCase(
      ChangePersonalInfoParams(
        fullName: fullName,
        phoneNumber: phoneNumber,
        image: image,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePersonalInfoState: RequestState.error,
          changePersonalInfoMessage: failure.message,
        ),
      ),
      (r) {
        emit(state.copyWith(changePersonalInfoState: RequestState.success));
        loadProfile();
        if (getIt.isRegistered<HomeCubitCandidate>()) {
          getIt<HomeCubitCandidate>().updateHomeHeaderName(fullName);
        }
      },
    );
  }

  Future<void> changePassword(String currentPass, String newPass) async {
    emit(state.copyWith(changePasswordStatus: RequestState.loading));
    final result = await changePasswordCandidateUseCase(
      ChangePasswordParams(currentPass, newPass),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePasswordStatus: RequestState.error,
          changePasswordMessage: failure.message,
        ),
      ),
      (r) {
        emit(state.copyWith(changePasswordStatus: RequestState.success));
        loadProfile();
      },
    );
  }

  Future<void> deleteAccount({
    required String currentEmail,
    required String currentPassword,
  }) async {
    emit(state.copyWith(deleteAccountStatus: RequestState.loading));
    final result = await deleteAccountCandidateUseCase(
      DeleteAccountCandidateParams(
        currentEmail: currentEmail,
        currentPassword: currentPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteAccountStatus: RequestState.error,
          deleteAccountMessage: failure.message,
        ),
      ),
      (r) {
        // 🌟 FIX: r is now String (the server message "Account deleted successfully.")
        // Previously the use case returned void so r was null and the message was always empty.
        emit(
          state.copyWith(
            deleteAccountStatus: RequestState.success,
            deleteAccountMessage: r,
          ),
        );
        logout();
      },
    );
  }

  Future<void> changeCareerDetails({
    required String newCvPath,
    required String oldCvData,
  }) async {
    emit(state.copyWith(changeCareerDetailsStatus: RequestState.loading));
    final result = await changeCareerDetailsUseCase(
      ChangeCareerDetailsParams(oldCvData: oldCvData, newCvPath: newCvPath),
    );
    result.fold(
      (l) => emit(
        state.copyWith(
          changeCareerDetailsStatus: RequestState.error,
          changeCareerDetailsMessage: l.message,
        ),
      ),
      (r) {
        emit(state.copyWith(changeCareerDetailsStatus: RequestState.success));
        loadProfile();
      },
    );
  }

  Future<void> pickCv() async {
    // تصفير الحالة قبل الاختيار
    emit(
      state.copyWith(
        cvUploadStatus: RequestState.initial,
        cvErrorMessage: '',
        cvUploadProgress: 0.0,
      ),
    );

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);

    if (file.lengthSync() > 5 * 1024 * 1024) {
      emit(
        state.copyWith(
          cvUploadStatus: RequestState.error,
          cvErrorMessage: "File must be less than 5MB",
        ),
      );
      return;
    }

    emit(state.copyWith(selectedCvFile: file));
    _uploadCv(file);
  }

  /// Upload CV (مؤقت) waiting for backend
  Future<void> _uploadCv(File file) async {
    emit(
      state.copyWith(
        cvUploadStatus: RequestState.loading,
        cvUploadProgress: 0.0,
      ),
    );

    for (int i = 1; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (isClosed) return; // تأمين عشان لو الشاشة اتقفلت وهو بيرفع

      emit(
        state.copyWith(
          cvUploadStatus: RequestState.loading,
          cvUploadProgress: i / 100,
        ),
      );
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          cvUploadStatus: RequestState.success,
          cvUploadProgress: 1.0,
        ),
      );
    }
  }

  void clearCv() {
    emit(
      state.copyWith(
        clearCvFile: true, // الحيلة اللي عملناها عشان نمسح الملف
        cvUploadStatus: RequestState.initial,
        cvUploadProgress: 0.0,
        cvErrorMessage: '',
      ),
    );
  }

  Future<void> confirmCurrentPassword({
    required String currentEmail,
    required String currentPassword,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(changeEmailPasswordCheckState: RequestState.loading));

    final result = await changeEmailEnterCurrentPasswordUseCase(
      ChangeEmailEnterCurrentPasswordParams(
        currentEmail: currentEmail,
        currentPassword: currentPassword,
      ),
    );
    result.fold(
      (l) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailPasswordCheckState: RequestState.error,
            changeEmailPasswordCheckMessage: l.message,
          ),
        );
      },
      (r) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailPasswordCheckState: RequestState.success,
            changeEmailPasswordCheckMessage: r,
          ),
        );
      },
    );
  }

  Future<void> sendCode({
    required String currentEmail,
    required String newEmail,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(changeEmailEmailCheckState: RequestState.loading));
    final result = await changeEmailEnterNewEmailUseCase(
      ChangeEmailEnterNewEmailParams(
        currentEmail: currentEmail,
        newEmail: newEmail,
      ),
    );
    result.fold(
      (l) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailEmailCheckState: RequestState.error,
            changeEmailEmailCheckMessage: l.message,
          ),
        );
      },
      (r) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailEmailCheckState: RequestState.success,
            changeEmailEmailCheckMessage: r,
          ),
        );
      },
    );
  }

  Future<void> verifyCode({
    required String currentEmail,
    required String newEmail,
    required String code,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(changeEmailOtpState: RequestState.loading));
    final result = await changeEmailOtpUseCase(
      ChangeEmailOtpParams(
        currentEmail: currentEmail,
        newEmail: newEmail,
        otp: code,
      ),
    );
    result.fold(
      (l) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailOtpState: RequestState.error,
            changeEmailOtpMessage: l.message,
          ),
        );
      },
      (r) {
        if (isClosed) return;
        emit(
          state.copyWith(
            changeEmailOtpState: RequestState.success,
            changeEmailOtpMessage: r,
          ),
        );
        loadProfile();
      },
    );
  }

  // ==================== Change Password (Final Flow) ====================

  Future<void> requestPasswordOtp({required String currentEmail}) async {
    if (isClosed) return;
    emit(state.copyWith(changePasswordOtpRequestState: RequestState.loading));
    final result = await changePasswordOtpRequestUseCase(
      ChangePasswordOtpRequestParams(currentEmail: currentEmail),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePasswordOtpRequestState: RequestState.error,
          changePasswordOtpRequestMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          changePasswordOtpRequestState: RequestState.success,
          changePasswordOtpRequestMessage: response,
        ),
      ),
    );
  }

  Future<void> checkPasswordOtp({
    required String currentEmail,
    required String otp,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(changePasswordOtpCheckState: RequestState.loading));
    final result = await changePasswordOtpCheckUseCase(
      ChangePasswordOtpCheckParams(currentEmail: currentEmail, otp: otp),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePasswordOtpCheckState: RequestState.error,
          changePasswordOtpCheckMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          changePasswordOtpCheckState: RequestState.success,
          changePasswordOtpCheckMessage: response.$1,
          changePasswordOtpCheckToken: response.$2,
        ),
      ),
    );
  }

  Future<void> verifyNewPassword({
    required String email,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(changePasswordVerifyState: RequestState.loading));
    final result = await changePasswordVerifyUseCase(
      ChangePasswordVerifyParams(
        currentEmail: email,
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePasswordVerifyState: RequestState.error,
          changePasswordVerifyMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          changePasswordVerifyState: RequestState.success,
          changePasswordVerifyMessage: response,
        ),
      ),
    );
  }

  // Reset OTP states for change password
  void resetPasswordOtpStates() {
    emit(
      state.copyWith(
        changePasswordOtpRequestState: RequestState.initial,
        changePasswordOtpRequestMessage: '',
        changePasswordOtpCheckState: RequestState.initial,
        changePasswordOtpCheckMessage: '',
        changePasswordVerifyState: RequestState.initial,
        changePasswordVerifyMessage: '',
      ),
    );
  }

  void resetDeleteAccountStates() {
    emit(
      state.copyWith(
        deleteAccountStatus: RequestState.initial,
        deleteAccountMessage: '',
      ),
    );
  }
}
