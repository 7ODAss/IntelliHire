import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'external_login_state.dart';

class ExternalLoginCubit extends Cubit<ExternalLoginState> {
  ExternalLoginCubit() : super(ExternalLoginInitial());

  StreamSubscription<Uri>? _linkSubscription;
  final _appLinks = AppLinks();

  void initDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      print("🔗🔗 Received External Login Link: $uri");

      if (uri.scheme == 'intellihire' &&
          uri.host == 'external-login-callback') {
        final token = uri.queryParameters['token'];
        final isProfileComplete =
            uri.queryParameters['isProfileComplete'] == 'true';

        // 🔴 التعديل هنا: نقرأ 'type' بدلاً من 'userType'
        final actualUserType = uri.queryParameters['type'] ?? '';
        final refreshToken = uri.queryParameters['refreshToken'];

        if (token != null && token.isNotEmpty) {
          try {
            await StorageService.saveToken(token);
            await CacheHelper.saveData(key: 'token', value: token);
            await CacheHelper.saveData(key: 'userType', value: actualUserType);
            if (refreshToken != null) {
              await CacheHelper.saveData(
                key: 'refreshToken',
                value: refreshToken,
              );
            }

            emit(
              ExternalLoginSuccess(token, isProfileComplete, actualUserType),
            );
          } catch (e) {
            emit(ExternalLoginFailure("Failed to save token securely."));
          }
        } else {
          emit(
            ExternalLoginFailure("Authentication failed. No token received."),
          );
        }
      }
    });
  }

  // باقي الدوال كما هي...
  Future<void> loginWithProvider({
    required String provider,
    required String type,
  }) async {
    emit(ExternalLoginLoading(provider));
    String baseUrl = "https://intellhire.runasp.net";
    final Uri url = Uri.parse(
      "$baseUrl/api/Auth/external-login?provider=$provider&type=$type&clientId=mobile",
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      emit(ExternalLoginFailure("An error occurred: $e"));
    }
  }

  @override
  Future<void> close() {
    _linkSubscription?.cancel();
    return super.close();
  }
}
