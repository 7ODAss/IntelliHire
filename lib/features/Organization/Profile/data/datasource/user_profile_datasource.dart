import 'package:dio/dio.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../../../../core/utils/apis/api_constant.dart';
import '../../../../../core/utils/apis/dio_config.dart';
import '../model/logout_model.dart';
import '../model/company_account_model.dart';


abstract class BaseUserProfileDataSource {
  Future<LogoutModel> logOutUserProfile();
  Future<void> updateCompanyInfo({
    required String name,
    required String industry,
    required String phoneNumber,
    String? photoPath,
  });
  Future<void> updateCompanyAbout({
    required String about,
    required String websiteUrl,
    required String country,
    required String government,
    required String city,
  });
  Future<CompanyAccountModel> getCompanyAccount();
  Future<void> requestEmailPasswordChange(String password, String currentEmail);
  Future<void> requestEmailChange(String currentEmail, String newEmail);
  Future<void> confirmEmailChange(String currentEmail, String newEmail, String code);
  Future<void> requestPasswordChange(String email);
  Future<String> sendOtp(String email, String code);
  Future<void> confirmPasswordChange({
    required String email,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<void> deleteCompanyAccount({
    required String email,
    required String currentPassword,
  });
}

class UserProfileDataSource extends BaseUserProfileDataSource {
  @override
  Future<LogoutModel> logOutUserProfile() async {
    final refreshToken = await CacheHelper.getData(key: 'refreshToken');

    final response = await DioConfig.postData(
      path: ApiConstant.logout,
      data: {
        'refreshToken': refreshToken,
        'deviceName': 'mobile'
      },
    );

    if (response.statusCode == 200) {
      await CacheHelper.removeData(key: 'token');
      await CacheHelper.removeData(key: 'refreshToken');
      await CacheHelper.removeData(key: 'userType');
      return LogoutModel.fromJson(response.data);
    } else {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> updateCompanyInfo({
    required String name,
    required String industry,
    required String phoneNumber,
    String? photoPath,
  }) async {
    MultipartFile? logoFile;
    if (photoPath != null && photoPath.isNotEmpty && !photoPath.startsWith('http')) {
      logoFile = await MultipartFile.fromFile(
        photoPath,
        filename: photoPath.split('/').last,
      );
    }

    final formData = FormData.fromMap({
      "Name": name,
      "Industry": industry,
      "PhoneNumber": phoneNumber,
      if (logoFile != null) "photo": logoFile,
    });

    final response = await DioConfig.patchData(
      path: ApiConstant.updateCompanyInfo,
      formData: formData,
    );

    print("--- [API RESPONSE] updateCompanyInfo ---");
    print("Status Code: ${response.statusCode}");
    print("Data: ${response.data}");

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> updateCompanyAbout({
    required String about,
    required String websiteUrl,
    required String country,
    required String government,
    required String city,
  }) async {
    final data = {
      "locations": {
        "city": city,
        "country": country,
        "government": government,
      },
      "about": about,
      "websiteUrl": websiteUrl,
    };

    print("--- [API REQUEST] updateCompanyAbout ---");
    print("Path: ${ApiConstant.updateCompanyAbout}");
    print("Body: $data");

    final response = await DioConfig.patchData(
      path: ApiConstant.updateCompanyAbout,
      data: data,
    );

    print("--- [API RESPONSE] updateCompanyAbout ---");
    print("Status Code: ${response.statusCode}");
    print("Data: ${response.data}");

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<CompanyAccountModel> getCompanyAccount() async {
    final response = await DioConfig.getData(
      path: ApiConstant.getCompanyAccount,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataMap = response.data['data'] as Map<String, dynamic>? ?? {};
      return CompanyAccountModel.fromJson(dataMap);
    } else {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> requestEmailPasswordChange(String password, String currentEmail) async {
    final response = await DioConfig.postData(
      path: ApiConstant.changeEmailPasswordRequest,
      data: {
        'currentPassword': password,
        'email': currentEmail,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> requestEmailChange(String currentEmail, String newEmail) async {
    final response = await DioConfig.postData(
      path: ApiConstant.changeEmailRequest,
      data: {
        'currentEmail': currentEmail,
        'newEmail': newEmail,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> confirmEmailChange(String currentEmail, String newEmail, String code) async {
    final response = await DioConfig.postData(
      path: ApiConstant.changeEmailConfirm,
      data: {
        'currentEmail': currentEmail,
        'newEmail': newEmail,
        'otpToken': code,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> requestPasswordChange(String email) async {
    final response = await DioConfig.postData(
      path: ApiConstant.requestPasswordChange,
      data: {
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<String> sendOtp(String email, String code) async {
    final response = await DioConfig.postData(
      path: ApiConstant.sendOtp,
      data: {
        'email': email,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['data'] ?? response.data['token'] ?? response.data['tokenValue'] ?? code;
      return token.toString();
    } else {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> confirmPasswordChange({
    required String email,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await DioConfig.postData(
      path: ApiConstant.confirmPasswordChange,
      data: {
        'email': email,
        'token': token,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> deleteCompanyAccount({
    required String email,
    required String currentPassword,
  }) async {
    final response = await DioConfig.putData(
      path: ApiConstant.deleteAccount,
      data: {
        'email': email,
        'currentPassword': currentPassword,
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
        serverMessage: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}