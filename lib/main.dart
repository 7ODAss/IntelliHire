import 'package:flutter/material.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/splash/presentation/view/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const  SplashView(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xffF8FAFC),
      ),
    );
  }
}
