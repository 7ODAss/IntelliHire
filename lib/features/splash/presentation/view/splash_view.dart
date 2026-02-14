import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/candidate_signup_view.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/logo_animation.json',
          width: double.infinity,
          fit: BoxFit.contain,
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(
              composition.duration + const Duration(seconds: 1),
              () {
                if (!mounted) return;
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,

                  MaterialPageRoute(
                    builder: (_) {
                      return CandidateSignUp();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
