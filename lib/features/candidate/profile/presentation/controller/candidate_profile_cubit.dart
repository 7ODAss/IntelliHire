import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_career_details_usecase.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../../../Organization/Profile/presentation/widgets/delete_account_confirm_dialog.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/usecases/change_password_candidate_usecase.dart';
import '../../domain/usecases/delete_account_candidate_usecase.dart';
import '../../domain/usecases/log_out_user_candidate_profile_usecase.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'candidate_profile_state.dart';

class CandidateProfileCubit extends Cubit<CandidateProfileState> {
  final FetchCandidateProfileUseCase fetchProfileUseCase;
  final ChangePasswordCandidateUseCase changePasswordCandidateUseCase;
  final DeleteAccountCandidateUseCase deleteAccountCandidateUseCase;
  final ChangeCareerDetailsUseCase changeCareerDetailsUseCase;
  final LogOutUserCandidateProfileUseCase logOutUserCandidateProfileUseCase;

  CandidateProfileCubit(
    this.fetchProfileUseCase,
    this.changePasswordCandidateUseCase,
    this.deleteAccountCandidateUseCase,
    this.changeCareerDetailsUseCase,
    this.logOutUserCandidateProfileUseCase,
  ) : super(const CandidateProfileState());

  // Career Details
  final TextEditingController currentRoleController = TextEditingController();
  final TextEditingController experienceYearsController =
      TextEditingController();
  final GlobalKey<FormState> careerDetailsInfoKey = GlobalKey<FormState>();

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
    emit(state.copyWith(status: RequestState.loading));
    final result = await fetchProfileUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestState.error,
          candidateProfileMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: RequestState.success,
          candidateProfileModel: profile,
        ),
      ),
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
      (r) => emit(state.copyWith(changePasswordStatus: RequestState.success)),
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(deleteAccountStatus: RequestState.loading));
    final result = await deleteAccountCandidateUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteAccountStatus: RequestState.error,
          deleteAccountMessage: failure.message,
        ),
      ),
      (r) {
        emit(state.copyWith(deleteAccountStatus: RequestState.success));
        logout();
      },
    );
  }

  Future<void> changeCareerDetails(ChangeCareerDetailsParams parameters) async {
    emit(state.copyWith(changeCareerDetailsStatus: RequestState.loading));
    final result = await changeCareerDetailsUseCase(parameters);
    result.fold(
      (l) => emit(
        state.copyWith(
          changeCareerDetailsStatus: RequestState.error,
          changeCareerDetailsMessage: l.message,
        ),
      ),
      (r) =>
          emit(state.copyWith(changeCareerDetailsStatus: RequestState.success)),
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
}
