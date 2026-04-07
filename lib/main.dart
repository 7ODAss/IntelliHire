import 'package:flutter/material.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';

import 'core/service/service_locator.dart';
import 'features/candidate/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper_candidate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  await CacheHelper.init();
  DioConfig.init();
  //CacheHelper.clearData();
  String? token = CacheHelper.getData(key: 'token');
  String? refreshToken = CacheHelper.getData(key: 'refreshToken');
  print('token: $token');
  print('refreshToken: $refreshToken');
  
  Widget widget;
  if (token != null) {
    widget = const CustomBottomNavBarWrapperCandidate();
  } else {
    widget = CustomBottomNavBarWrapperCandidate();
  }
  
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startWidget,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xffF8FAFC),
      ),
    );
  }
}
