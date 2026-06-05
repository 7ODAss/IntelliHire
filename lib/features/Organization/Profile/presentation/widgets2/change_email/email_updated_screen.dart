import 'package:flutter/material.dart';
import 'package:intelli_hire/features/auth/presentation/login/widget/button_action.dart';

class EmailUpdatedScreen extends StatelessWidget {
  final String newEmail;

  const EmailUpdatedScreen({super.key, required this.newEmail});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Email updated successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Your email is now $newEmail',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: ButtonAction(
                    title: 'Done',
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
