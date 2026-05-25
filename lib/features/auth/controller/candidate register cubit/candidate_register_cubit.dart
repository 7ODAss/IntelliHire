import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/device_helper.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'candidate_register_state.dart';

class CandidateRegisterCubit extends Cubit<CandidateRegisterState> {
  final ApiService apiService;

  CandidateRegisterCubit(this.apiService) : super(CandidateRegisterInitial());

  String? savedName;
  String? savedEmail;
  String? savedPassword;

  String? userToken;
  String? refreshToken;
  String? expiresOn;

  void saveFirstStep({
    required String name,
    required String email,
    required String password,
  }) {
    savedName = name;
    savedEmail = email;
    savedPassword = password;
  }

  Future<void> registerCandidate() async {
    if (isClosed) return;
    emit(CandidateRegisterLoading());

    String currentDeviceName = await DeviceHelper.getDeviceName();

    try {
      Map<String, dynamic> requestData = {
        "name": savedName,
        "email": savedEmail,
        "password": savedPassword,
        "confirmPassword": savedPassword,
        "deviceName": currentDeviceName,
      };

      var response = await apiService.post(
        endPoint: 'api/Auth/register/candidate',
        data: requestData,
      );

      if (response.data != null && response.data['token'] != null) {
        userToken = response.data['token'];
        refreshToken = response.data['refreshToken'];
        expiresOn = response.data['expiresOn'];

        await StorageService.saveToken(userToken!);
      }
      emit(CandidateRegisterSuccess());
    } on DioException catch (e) {
      bool isStep1Error = false;
      String errorMsg = 'A server error occurred during registration';

      if (e.response?.data != null && e.response?.data is Map) {
        var data = e.response?.data;
        if (data['errors'] != null) {
          Map<String, dynamic> errors = data['errors'];
          errorMsg = errors.values.first[0].toString();
        } else {
          errorMsg = data['message'] ?? errorMsg;
        }
      }

      String lowerErrorMsg = errorMsg.toLowerCase();
      if (lowerErrorMsg.contains('password') ||
          lowerErrorMsg.contains('email') ||
          lowerErrorMsg.contains('name') ||
          lowerErrorMsg.contains('username')) {
        isStep1Error = true;
      }

      emit(CandidateRegisterFailure(errorMsg, isStep1Error: isStep1Error));
    } catch (e) {
      emit(CandidateRegisterFailure("An unexpected error occurred"));
    }
  }

  Future<void> confirmEmailFromServer({
    required String userId,
    required String token,
  }) async {
    emit(EmailConfirmationLoading());
    try {
      var response = await apiService.dio.get(
        'api/Auth/confirm-email',
        queryParameters: {'userId': userId, 'token': token},
      );

      if (response.data != null && response.data['token'] != null) {
        userToken = response.data['token'];
        await StorageService.saveToken(userToken!);
      }

      emit(EmailConfirmationSuccess());
    } on DioException {
      emit(EmailConfirmationFailure("Verification failed or link expired."));
    }
  }

  Future<void> saveTokenFromDeepLink(String verificationToken) async {
    emit(EmailConfirmationSuccess());

    if (userToken != null) {
      await StorageService.saveToken(userToken!);
    }
  }
}
