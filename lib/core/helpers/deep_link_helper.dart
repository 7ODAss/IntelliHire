import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/apis/api_constant.dart';

import '../../features/auth/controller/sign_up_cubit/sign_up_cubit.dart';
import '../../features/auth/presentation/signup/company/widget/verify_screen.dart';

class DeepLinkHelper {
  final _appLinks = AppLinks();

  void initDeepLinks() {
    _appLinks.uriLinkStream
        .listen((Uri? uri) {
          if (uri != null) {
            _handleLink(uri);
          }
        })
        .onError((error) {});
  }

  void _handleLink(Uri uri) {
    if (uri.host == 'confirm-email') {
      final token = uri.queryParameters['token'];
      final userId = uri.queryParameters['userId'];

      if (token != null && userId != null) {
        final context = ApiConstant.navigatorKey.currentContext;

        if (context != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => SignUpCubit(),
                child: VerifyScreen(token: token, userId: userId),
              ),
            ),
          );
        }
      }
    }
  }
}
