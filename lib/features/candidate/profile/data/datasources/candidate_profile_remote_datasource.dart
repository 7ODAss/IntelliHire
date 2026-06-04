import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intelli_hire/features/candidate/profile/data/models/logout_model.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_current_password_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_enter_new_email_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_email_otp_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_password_candidate_usecase.dart';
import 'package:intelli_hire/features/candidate/profile/domain/usecases/change_personal_info_usecase.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../../../../core/utils/apis/api_constant.dart';
import '../../../../../core/utils/apis/dio_config.dart';
import '../../domain/usecases/change_career_details_usecase.dart';
import '../models/candidate_profile_model.dart';
import 'package:http_parser/http_parser.dart';

abstract class BaseCandidateProfileDataSource {
  Future<CandidateProfileModel> fetchProfile();
  Future<void> updatePersonalInfoProfile({
    required String fullName,
    required String phoneNumber,
    File? image,
  });
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount();
  Future<void> changeCareerDetails(String? newCvPath, String? oldCvData);
  Future<LogoutCandidateModel> logOutUserCandidateProfile();
  Future<String> changeEmailEnterCurrentPassword({
    required String currentEmail,
    required String currentPassword,
  });
  Future<String> changeEmailEnterNewEmail({
    required String currentEmail,
    required String newEmail,
  });
  Future<String> changeEmailOtp({
    required String otp,
    required String newEmail,
    required String currentEmail,
  });
}

/// Stub with dummy profile — swap for real API when backend is ready.
class CandidateProfileRemoteDataSource
    implements BaseCandidateProfileDataSource {
  @override
  Future<CandidateProfileModel> fetchProfile() async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.candidateProfile,
      );
      if (response.statusCode == 200) {
        print('profile respomse: $response');
        return CandidateProfileModel.fromJson(response.data);
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 [STATUS CODE]: ${e.response?.statusCode}');
        print('🚨 [SERVER RAW RESPONSE]: ${e.response?.data}');
        print(
          '🚨 [DIO EXCEPTION TYPE]: ${e.type}',
        ); // 🌟 ده هيقولك بالظبط ليه الـ response بـ null (مثلاً DioExceptionType.cancel)
        print('🚨 [ERROR MESSAGE]: ${e.message}');
        print('🚨 [EXACT URL SENT]: ${e.requestOptions.uri}');
      }
      rethrow;
    }
  }

  @override
  Future<void> updatePersonalInfoProfile({
    required String fullName,
    required String phoneNumber,
    File? image,
  }) async {
    try {
      final Map<String, dynamic> bodyFields = {
        'FullName': fullName,
        'PhoneNumber': phoneNumber,
      };

      if (image != null) {
        String fileName = image.path.split('/').last;
        bodyFields['Photo'] = await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(bodyFields);

      final response = await DioConfig.patchData(
        path: ApiConstant.candidateChangePersonalInfoProfile,
        formData: formData,
      );

      if (response.statusCode == 200) {
        print('✅ Changed successfully');
        print('Response: ${response.data}');
        return response.data;
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data['success']),
        );
      }
    } catch (e) {
      if (e is DioException) {
        print('🚨 تفاصيل رفض السيرفر (Multipart): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
        throw e.response?.data['success'];
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<LogoutCandidateModel> logOutUserCandidateProfile() async {
    try {
      final refreshToken = await CacheHelper.getData(key: 'refreshToken');

      final response = await DioConfig.postData(
        path: ApiConstant.logout,
        data: {'refreshToken': refreshToken, 'deviceName': 'mobile'},
      );

      if (response.statusCode == 200) {
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'expiresOn');
        await CacheHelper.removeData(key: 'userType');
        return LogoutCandidateModel.fromJson(response.data);
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateChangePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        print('changed');
        print('response: ${response.data}');
        return response.data;
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await DioConfig.deleteData(
        path: ApiConstant.candidateDeleteAccount,
      );
      if (response.statusCode == 200) {
        print('deleted');
        print('response: ${response.data}');
        return response.data;
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> changeCareerDetails(String? newCvPath, String? oldCvData) async {
    try {
      final Map<String, dynamic> dataMap = {};

      if (newCvPath != null && newCvPath!.isNotEmpty) {
        dataMap["CvFile"] = await MultipartFile.fromFile(
          newCvPath!,
          filename: newCvPath!.split('/').last,
        );
      }
      // 🌟 2. لو مفيش ملف جديد، هل في داتا قديمة مبعوتة？
      else if (oldCvData != null && oldCvData!.isNotEmpty) {
        dataMap["CvFile"] = MultipartFile.fromBytes(
          base64Decode(oldCvData!),
          filename: 'resume.pdf',
        );
      }

      final formData = FormData.fromMap(dataMap);
      final response = await DioConfig.patchData(
        path: ApiConstant.candidateChangeCareerDetails,
        formData: formData,
      );
      if (response.statusCode == 200) {
        print('data changed');
        print('response: ${response.data}');
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data),
        );
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<String> changeEmailEnterCurrentPassword({
    required currentEmail,
    required String currentPassword,
  }) async {
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateChangeEmailVerifyPass,
        data: {'email': currentEmail, 'currentPassword': currentPassword},
      );
      if (response.statusCode == 200) {
        print('password verified');
        print('response: ${response.data}');
        return response.data['message'];
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data['message']),
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data['message'];
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<String> changeEmailEnterNewEmail({
    required String currentEmail,
    required String newEmail,
  }) async {
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateChangeEmailRequestOtp,
        data: {'currentEmail': currentEmail, 'newEmail': newEmail},
      );
      if (response.statusCode == 200) {
        print('OTP requested');
        print('response: ${response.data}');
        return response.data['message'];
      } else {
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(response.data['message']),
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data['message'];
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<String> changeEmailOtp({
    required String otp,
    required String newEmail,
    required String currentEmail,
  }) async {
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateChangeEmailConfirmOtp,
        data: {
          'currentEmail': currentEmail,
          'newEmail': newEmail,
          'otpToken': otp,
        },
      );
      if (response.statusCode == 200) {
        print('OTP verified');
        print('response: ${response.data}');
        return response.data['message'];
      } else {
        print('دخل جوه ال else');
        throw ServerException(
          serverMessage: ErrorMessageModel.fromJson(
            response.data['errors'][0]['description'],
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data['errors'][0]['description'];
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }
}
