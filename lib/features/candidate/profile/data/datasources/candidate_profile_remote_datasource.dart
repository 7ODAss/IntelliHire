import 'package:dio/dio.dart';
import 'package:intelli_hire/features/candidate/profile/data/models/logout_model.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../../../../core/utils/apis/api_constant.dart';
import '../../../../../core/utils/apis/dio_config.dart';
import '../../domain/usecases/change_career_details_usecase.dart';
import '../models/candidate_profile_model.dart';

abstract class BaseCandidateProfileDataSource {
  Future<CandidateProfileModel> fetchProfile();
  Future<CandidateProfileModel> updateProfile(CandidateProfileModel profile);
  Future<void> changePassword(String currentPass, String newPass);
  Future<void> deleteAccount();
  Future<void> changeCareerDetails(ChangeCareerDetailsParams parameters);
  Future<LogoutCandidateModel> logOutUserCandidateProfile();
}

/// Stub with dummy profile — swap for real API when backend is ready.
class CandidateProfileRemoteDataSource implements BaseCandidateProfileDataSource {
  @override
  Future<CandidateProfileModel> fetchProfile() async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.candidateProfile,
      );
      if (response.statusCode == 200) {
        return CandidateProfileModel.fromJson(response.data);
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
  Future<CandidateProfileModel> updateProfile(
    CandidateProfileModel profile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return profile;
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
  Future<void> changePassword(String currentPass, String newPass) async {
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateChangePassword,
        data: {'currentPassword': currentPass, 'newPassword': newPass},
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
  Future<void> changeCareerDetails(ChangeCareerDetailsParams parameters) async{
    try {
      MultipartFile? cvFile;
      if (parameters.cv.isNotEmpty ) {
        cvFile = await MultipartFile.fromFile(
          parameters.cv,
          filename: parameters.cv.split('/').last, // بياخد اسم الملف الحقيقي
        );
      }

      final formData = FormData.fromMap({
        "CurrentRole": parameters.currentRole,
        "ExperienceYears": parameters.experienceYears,
        "CvFile": cvFile,

      });
      final response = await DioConfig.patchData(
        path: ApiConstant.candidateChangeCareerDetails,
        formData:formData
      );
      if (response.statusCode == 200) {
        print('data changed');
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
}
