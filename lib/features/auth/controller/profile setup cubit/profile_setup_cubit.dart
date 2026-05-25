import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final ApiService apiService;
  final String userToken;

  ProfileSetupCubit(this.apiService, {required this.userToken})
    : super(ProfileInitial());

  File? selectedCv;
  File? selectedImage;
  String? phoneNumber;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPickerActive = false;
  bool _isCvPickerActive = false;

  void setPhoneNumber(String phone) {
    phoneNumber = phone;
  }

  Future<void> pickCv() async {
    if (_isCvPickerActive) return;
    _isCvPickerActive = true;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        if (file.lengthSync() <= 5 * 1024 * 1024) {
          selectedCv = file;
          emit(ProfileFilePicked());
        } else {
          emit(ProfileError("CV size must be less than 5 MB"));
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
        imageQuality: 50, //
      );

      if (image != null) {
        selectedImage = File(image.path);
        emit(ProfileFilePicked());
      }
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> uploadProfileData() async {
    if (selectedCv == null || selectedImage == null || phoneNumber == null) {
      emit(ProfileError("Please ensure Phone, CV and Photo are provided"));
      return;
    }

    emit(ProfileUploading(0.0));

    try {
      FormData formData = FormData.fromMap({
        "PhoneNumber": phoneNumber,
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
        'api/Profile/UserComplete',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (int sent, int total) {
          if (total != -1) {
            double progress = sent / total;

            if (state is! ProfileUploading ||
                (progress - (state as ProfileUploading).progress).abs() >
                    0.05) {
              emit(ProfileUploading(progress));
            }
          }
        },
      );

      emit(ProfileSuccess());
    } on DioException catch (e) {
 
      String errorMsg = 'Failed to complete profile';

      if (e.response?.data != null &&
          e.response!.data.toString().trim().isNotEmpty) {
        if (e.response?.data is Map) {
          errorMsg =
              e.response?.data['message'] ??
              e.response?.data['title'] ??
              'Server Error';
        } else {
          errorMsg = e.response!.data.toString();
        }
      } else {
        // لو الرد فاضي، يظهر رقم الكود (مثلاً 400 أو 401)
        errorMsg =
            "Server Error (${e.response?.statusCode ?? 'Connection Error'})";
      }

      emit(ProfileError(errorMsg));
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
