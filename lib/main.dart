import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:intelli_hire/core/helpers/cache_helper.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import 'package:intelli_hire/features/auth/presentation/login/login_screen.dart';
import 'package:intelli_hire/features/splash/presentation/view/splash_view.dart';
import 'core/helpers/deep_link_helper.dart';
import 'core/service/service_locator.dart';
import 'core/utils/apis/api_constant.dart';
import 'features/Organization/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper.dart';
import 'features/candidate/bottom _navigation/presentation/custom_bottom_nav_bar_wrapper_candidate.dart';
import 'features/auth/controller/external login/external_login_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  DioConfig.init();
  //await CacheHelper.clearData();
  await dotenv.load(fileName: ".env");
  ServiceLocator().init();
  String? token = await CacheHelper.getData(key: 'token');
  String? refreshToken = await CacheHelper.getData(key: 'refreshToken');
  String? userType = await CacheHelper.getData(key: 'userType');
  String? expiresOn = await CacheHelper.getData(key: 'expiresOn');
  DateTime? expiresOnDateTime = expiresOn != null
      ? DateTime.parse(expiresOn)
      : null;
  String? showVal = await CacheHelper.getData(key: 'do_not_show');
  bool doNotShow = showVal == 'true';
  print('token: $token');
  print('refreshToken: $refreshToken');
  print('userType: $userType');
  print('expiresOnDateTime: $expiresOnDateTime');
  print('do_not_show: $doNotShow');

  Widget widget;
  if (token != null) {
    if (userType == 'Company') {
      widget = const CustomBottomNavBarWrapper();
    } else {
      widget = const CustomBottomNavBarWrapperCandidate();
    }
  } else {
    widget = const SplashView();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatefulWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkHelper _deepLinkHelper = DeepLinkHelper();

  @override
  void initState() {
    super.initState();
    _deepLinkHelper.initDeepLinks();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ExternalLoginCubit()..initDeepLinkListener(),
      child: MaterialApp(
        navigatorKey: ApiConstant.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: widget.startWidget,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xffF8FAFC),
        ),

      ),
    );
  }
}
