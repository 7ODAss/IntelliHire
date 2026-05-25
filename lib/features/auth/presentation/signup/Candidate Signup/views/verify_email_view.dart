import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/service/storage_service.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_state.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/account_setup_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri);
    });
  }

  void _handleLink(Uri uri) {
    if (uri.scheme == 'intellihire' && uri.host == 'confirm-email') {
      final token = uri.queryParameters['token'];
      final userId = uri.queryParameters['userId'];

      if (token != null && userId != null) {
        context.read<CandidateRegisterCubit>().confirmEmailFromServer(
          userId: userId,
          token: token,
        );
      }
    }
  }

  void _navigateToSuccessScreen() async {
    final registrationCubit = context.read<CandidateRegisterCubit>();
    String? token = registrationCubit.userToken;

    if (token == null || token.isEmpty) {
      token = await StorageService.getToken();
    }


    if (token == null || token.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Authentication Error: Please login again."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // بنحدث الكيوبت عشان لو احتاجه
    registrationCubit.userToken = token;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ProfileSetupCubit(ApiService(), userToken: token!),
            child: const AccountSetupView(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CandidateRegisterCubit, CandidateRegisterState>(
        listener: (context, state) {
          if (state is EmailConfirmationSuccess) {
            _navigateToSuccessScreen();
          } else if (state is EmailConfirmationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Verification Failed: ${state.errorMsg}"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EmailConfirmationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Verifying your email..."),
                ],
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Check your email",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "We've sent a verification link to your email address. Please click the link to activate your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),

                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
