import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/upload%20cv%20cubit/uploadcv_state.dart';

class UploadCvCubit extends Cubit<UploadCvState> {
  UploadCvCubit() : super(UploadCvInitial());

  File? selectedFile;

  /// Pick CV
  Future<void> pickCv() async {
    emit(UploadCvInitial());

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null) {
      emit(UploadCvInitial());
      return;
    }

    final file = File(result.files.single.path!);

    if (file.lengthSync() > 5 * 1024 * 1024) {
      emit(UploadCvError("File must be less than 5MB"));
      return;
    }

    selectedFile = file;
    uploadCv();
  }

  /// Upload CV (مؤقت) waiting for backend
  Future<void> uploadCv() async {
    if (selectedFile == null) {
      emit(UploadCvError("Please select a CV first"));
      return;
    }

    for (int i = 1; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 250));
      emit(UploadCvUploading(i / 100));
    }

    if (!isClosed) emit(UploadCvSuccess(selectedFile!));
  }

  void clearCv() {
    selectedFile = null;
    emit(UploadCvInitial());
  }
}
