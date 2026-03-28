import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/device_helper.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'candidate_register_state.dart';

class CandidateRegisterCubit extends Cubit<CandidateRegisterState> {
  final ApiService apiService;

  CandidateRegisterCubit(this.apiService) : super(CandidateRegisterInitial());

  String? savedName;
  String? savedEmail;
  String? savedPassword;
  String? savedPhone;
  String? userToken;

  void saveFirstStep({
    required String name,
    required String email,
    required String password,
  }) {
    savedName = name;
    savedEmail = email;
    savedPassword = password;
  }

  Future<void> registerCandidate(String phone) async {
    emit(CandidateRegisterLoading());
    savedPhone = phone;

    String currentDeviceName = await DeviceHelper.getDeviceName();

    try {
      Map<String, dynamic> requestData = {
        "name": savedName,
        "email": savedEmail,
        "password": savedPassword,
        "phoneNumber": phone,
        "deviceName": currentDeviceName,
      };
      var response = await apiService.post(
        endPoint: 'api/Auth/register/candidate',
        data: requestData,
      );
      
      if (response.data != null && response.data['token'] != null) {
        userToken = response.data['token'];
      }
      emit(CandidateRegisterSuccess());
    } 
    on DioException catch (e) {
      bool isStep1Error = false;
      String errorMsg = 'حدث خطأ من السيرفر أثناء التسجيل';

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
      emit(CandidateRegisterFailure("حدث خطأ غير متوقع"));
    }
  }
}
