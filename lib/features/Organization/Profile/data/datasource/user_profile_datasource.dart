import '../../../../../core/error/exception.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/network/error_message_model.dart';
import '../../../../../core/utils/apis/api_constant.dart';
import '../../../../../core/utils/apis/dio_config.dart';
import '../model/logout_model.dart';

abstract class BaseUserProfileDataSource {
  Future<LogoutModel> logOutUserProfile();
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
}