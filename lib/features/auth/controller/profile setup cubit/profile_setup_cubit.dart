import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final ApiService apiService;

  ProfileSetupCubit(this.apiService) : super(ProfileInitial());

  File? selectedCv;
  File? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPickerActive = false;
  bool _isCvPickerActive = false;

  Future<void> pickCv() async {
    if (_isCvPickerActive) return;
    _isCvPickerActive = true;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        if (file.lengthSync() <= 5 * 1024 * 1024) {
          selectedCv = file;
          emit(ProfileFilePicked());
        } else {
          emit(ProfileError("حجم الـ CV يجب أن يكون أقل من 5 ميجا"));
        }
      }
    } finally {
      _isCvPickerActive = false;
    }
  }

  Future<void> pickImage() async {
    if (_isPickerActive) return;

    _isPickerActive = true;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage = File(image.path);
        emit(ProfileFilePicked());
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> uploadProfileData(String userToken) async {
    if (selectedCv == null || selectedImage == null) {
      emit(ProfileError("برجاء اختيار الـ CV والصورة الشخصية"));
      return;
    }

    emit(ProfileUploading(0.0));

    try {
      FormData formData = FormData.fromMap({
        "CV": await MultipartFile.fromFile(
          selectedCv!.path,
          filename: selectedCv!.path.split('/').last,
        ),
        "Photo": await MultipartFile.fromFile(
          selectedImage!.path,
          filename: selectedImage!.path.split('/').last,
        ),
      });

      await apiService.dio.post(
        '${apiService.baseUrl}api/Profile/complete',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
        onSendProgress: (int sent, int total) {
          emit(ProfileUploading(sent / total));
        },
      );

      emit(ProfileSuccess());
    } on DioException catch (e) {
      String errorMsg = e.response?.data['message'] ?? 'فشل رفع الملفات';
      emit(ProfileError(errorMsg));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void clearCv() {
    selectedCv = null;
    emit(ProfileInitial());
  }

  void clearImage() {
    selectedImage = null;
    emit(ProfileInitial());
  }
}
