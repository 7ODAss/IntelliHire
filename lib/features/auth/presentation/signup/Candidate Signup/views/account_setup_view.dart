import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Account%20Setup/phone_number.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Account%20Setup/account_setup_header.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/Account%20Setup/profile_photo.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/upload_cv_view.dart';

class AccountSetupView extends StatefulWidget {
  const AccountSetupView({super.key});

  @override
  State<AccountSetupView> createState() => _AccountSetupViewState();
}

class _AccountSetupViewState extends State<AccountSetupView> {
  int activeStep = 0;
  

  final List<String> titles = [
    'Enter your phone number',
    'Upload your CV',
    'Add a profile photo',
  ];

  void nextStep() {
    if (activeStep < 2) {
      setState(() => activeStep++);
    }
  }

  void previousStep() {
    if (activeStep > 0) {
      setState(() => activeStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AccountSetupHeader(
            screenNumber: activeStep,
            title: titles[activeStep],
            onPressed: previousStep,
          ),
          Expanded(
            child: IndexedStack(
              index: activeStep,
              children: [
                PhoneNumber(onPressed: nextStep),
                UploadCv(onPressed: nextStep),
                ProfilePhoto(onPressed: nextStep),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
